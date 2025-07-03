import Foundation

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]? = nil
    var body: Data? = nil

    private static let baseURL = "http://localhost:8080/api/v1"

    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: Self.baseURL + path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        request.setValue("applications/json", forHTTPHeaderField: "Content-Type")

        if let token = TokenStorage.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
