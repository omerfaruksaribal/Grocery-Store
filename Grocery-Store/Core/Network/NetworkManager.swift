import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>( _ endpoint: Endpoint, decodeTo type: T.Type ) async throws -> T
}

final class NetworkManager: NetworkServiceProtocol {

    // MARK: public
    func request<T: Decodable>( _ endpoint: Endpoint, decodeTo type: T.Type ) async throws -> T {
        let urlRequest = try endpoint.asURLRequest()

        func perform() async throws -> (data: Data, response: URLResponse) {
            if #available(iOS 15, *) {
                return try await URLSession.shared.data(for: urlRequest)
            } else {
                return try await withCheckedThrowingContinuation { cont in
                    URLSession.shared.dataTask(with: urlRequest) { data, resp, err in
                        if let err {
                            cont.resume(throwing: err)
                            return
                        }
                        guard let data, let resp else {
                            cont.resume(throwing: URLError(.badServerResponse))
                            return
                        }
                        cont.resume(returning: (data, resp))
                    }.resume()
                }
            }
        }

        var (data, resp) = try await perform()

        if Self.isUnauthorized(resp) {
            try await Self.refreshIfPossible()
            (data, resp) = try await perform()
        }

        try Self.validate(resp)

        return try Self.decode(data, as: type)


    }

    // MARK: helpers
    private static func validate(_ resp: URLResponse?) throws {
        guard
            let http = resp as? HTTPURLResponse,
            (200..<300).contains(http.statusCode)
        else { throw URLError(.badServerResponse) }
    }

    private static func decode<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601          // Instant / LocalDateTime
        return try dec.decode(type, from: data)
    }

    private static func isUnauthorized(_ resp: URLResponse?) -> Bool {
        guard let http = resp as? HTTPURLResponse else { return false }
        return http.statusCode == 401 || http.statusCode == 403
    }

    private static func refreshIfPossible() async throws {
        guard let refresh = TokenStorage.refreshToken else {
            throw URLError(.userAuthenticationRequired)
        }

        let tokens = try await AuthService().refresh(using: refresh)
        TokenStorage.save(tokens)
    }
}
