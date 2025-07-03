import Foundation

//  MARK: - Endpoint Factory
private enum AuthEndpoint {
    case register(RegisterRequest)
    case login(LoginRequest)
    case refresh(RefreshTokenRequest)
    case activate(ActivateAccountRequest)
    case forgotPassword(ForgotPasswordRequest)
    case resetPassword(ResetPasswordRequest)
    

    var value: Endpoint {
        switch self {
        case .register(let payload):
            let body = try? JSONEncoder().encode(payload)
            return Endpoint(path: "/auth/register", method: .POST, body: body)
        case .login(let payload):
            let body = try? JSONEncoder().encode(payload)
            return Endpoint(path: "/auth/login", method: .POST, body: body)
        case .refresh(let payload):
            let body = try? JSONEncoder().encode(payload)
            return Endpoint(path: "/auth/refresh-token", method: .POST, body: body)
        case .activate(let payload):
            let body = try? JSONEncoder().encode(payload)
            return Endpoint(path: "/auth/activate", method: .POST, body: body)
        case .forgotPassword(let payload):
            let body = try? JSONEncoder().encode(payload)
            return Endpoint(path: "/auth/forgot-password", method: .POST, body: body)
        case .resetPassword(let payload):
            let body = try? JSONEncoder().encode(payload)
            return Endpoint(path: "/auth/reset-password", method: .PATCH, body: body)
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

    /// /auth/refresh-token → ApiResponse<LoginTokens>
    func refresh(using refreshToken: String) async throws -> LoginTokens {
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        let endpoint = AuthEndpoint.refresh(request).value
        let response: ApiResponse<LoginTokens> = try await network.request(
            endpoint,
            decodeTo: ApiResponse<LoginTokens>.self
        )
        guard let token = response.data else { throw URLError(.cannotParseResponse) }

        return token
    }

    /// /auth/activate → ApiResponse<String>
    func activate(_ req: ActivateAccountRequest) async throws -> ApiResponse<String> {
        let endpoint = AuthEndpoint.activate(req).value
        return try await network.request(endpoint, decodeTo: ApiResponse<String>.self)
    }

    /// /auth/forgot-password → ApiResponse<ForgotPasswordResponseData>
    func forgotPassword(_ req: ForgotPasswordRequest) async throws -> ApiResponse<ForgotPasswordResponseData> {
        let endpoint = AuthEndpoint.forgotPassword(req).value
        return try await network.request(
            endpoint,
            decodeTo: ApiResponse<ForgotPasswordResponseData>.self
        )
    }

    /// /auth/reset-password→ ApiResponse<ResetPasswordResponseData>
    func resetPassword(_ req: ResetPasswordRequest) async throws -> ApiResponse<ResetPasswordResponseData> {
        let endpoint = AuthEndpoint.resetPassword(req).value
        return try await network.request(
            endpoint,
            decodeTo: ApiResponse<ResetPasswordResponseData>.self
        )
    }
}

