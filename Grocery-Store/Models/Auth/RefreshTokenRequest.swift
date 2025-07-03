struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

typealias RefreshTokenResponseData = LoginTokens
