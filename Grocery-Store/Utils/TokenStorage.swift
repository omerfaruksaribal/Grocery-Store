import Foundation

enum TokenStorage {
    private static let key = "grocery.tokens"

    static var current: LoginTokens? {
        guard let data = KeychainHelper.load(key: key) else { return nil }

        return try? JSONDecoder().decode(LoginTokens.self, from: data)
    }

    @discardableResult
    static func save(_ tokens: LoginTokens) -> Bool {
        guard let data = try? JSONEncoder().encode(tokens) else { return false }

        let status = KeychainHelper.save(key: key, data: data)
        return status == errSecSuccess
    }

    @discardableResult
    static func clear() -> Bool {
        KeychainHelper.delete(key: key) == errSecSuccess
    }

    //  MARK: - Convenience
    static var accessToken: String? { current?.accessToken }
    static var refreshToken: String? { current?.refreshToken }

}
