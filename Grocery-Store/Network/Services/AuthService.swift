import Foundation

//  MARK: - Endpoint Factory
private enum AuthEndpoint {
    case register(RegisterRequest)

    case login(LoginRequest)

    var value: Endpoint {
        switch self {
        case .register(let payload):
            let body = try? JSONEncoder().encode(payload)
            return Endpoint(path: "/auth/register", method: .POST, body: body)
        case .login(let payload):
            let body = try? JSONEncoder().encode(payload)
            return Endpoint(path: "/auth/login", method: .POST, body: body)
        }
    }
}

//  MARK: - service
final class AuthService {
    private let network: NetworkServiceProtocol
    init(network: NetworkServiceProtocol = NetworkManager()) {
        self.network = network
    }

    /// /auth/register → ApiResponse<RegisterResponseData>
    func register(_ req: RegisterRequest) async throws -> ApiResponse<RegisterResponseData> {

        let endpoint = AuthEndpoint.register(req).value

        return try await network.request(
            endpoint,
            decodeTo: ApiResponse<RegisterResponseData>.self
        )
    }

    /// /auth/login → ApiResponse<LoginResponseData>
    func login(_ req: LoginRequest) async throws -> ApiResponse<LoginResponseData> {

        let endpoint = AuthEndpoint.login(req).value

        return try await network.request(
            endpoint,
            decodeTo: ApiResponse<LoginResponseData>.self
        )
    }
}

