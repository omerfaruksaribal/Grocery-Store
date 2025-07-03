import Foundation
import Security

enum KeychainHelper {
    //  MARK: - Public API
    @discardableResult
    static func save(
        key: String,
        data: Data,
        accessGroup: String? = nil,
        accessible: CFString = kSecAttrAccessibleAfterFirstUnlock
    ) -> OSStatus {
        delete(key: key, accessGroup: accessGroup)

        var query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecValueData as String : data,
            kSecAttrAccessible as String: accessible
        ]

        if let accessGroup { query[kSecAttrAccessGroup as String] = accessGroup }
        return SecItemAdd(query as CFDictionary, nil)
    }

    static func load(key: String, accessGroup: String? = nil) -> Data? {
        var query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String : kCFBooleanTrue!,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        if let accessGroup { query[kSecAttrAccessGroup as String] = accessGroup }

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        return status == errSecSuccess ? item as? Data : nil
    }


    @discardableResult
    static func delete(key: String, accessGroup: String? = nil) -> OSStatus {
        var query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key
        ]

        if let accessGroup { query[kSecAttrAccessGroup as String] = accessGroup }
        return SecItemDelete(query as CFDictionary)
    }
}
