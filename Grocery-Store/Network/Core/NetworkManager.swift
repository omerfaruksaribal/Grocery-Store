import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>( _ endpoint: Endpoint, decodeTo type: T.Type ) async throws -> T
}

final class NetworkManager: NetworkServiceProtocol {

    // MARK: public
    func request<T: Decodable>( _ endpoint: Endpoint, decodeTo type: T.Type ) async throws -> T {
        let urlRequest = try endpoint.asURLRequest()

        if #available(iOS 15, macOS 12, *) {
            let (data, resp) = try await URLSession.shared.data(for: urlRequest)
            try Self.validate(resp)
            return try Self.decode(data, as: type)
        } else {
            return try await withCheckedThrowingContinuation { cont in
                URLSession.shared.dataTask(with: urlRequest) { data, resp, err in
                    if let err { return cont.resume(throwing: err) }
                    do {
                        try Self.validate(resp)
                        guard let data else { throw URLError(.badServerResponse) }
                        let decoded = try Self.decode(data, as: type)
                        cont.resume(returning: decoded)
                    } catch {
                        cont.resume(throwing: error)
                    }
                }.resume()
            }
        }
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
}
