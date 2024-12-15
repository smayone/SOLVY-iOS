import Foundation
import Security

/// Error types for KeychainService operations
enum KeychainError: Error {
    case saveFailed
    case readFailed
    case deleteFailed
    case itemNotFound
    case invalidData
    
    var localizedDescription: String {
        switch self {
        case .saveFailed:
            return "Failed to save item to Keychain"
        case .readFailed:
            return "Failed to read item from Keychain"
        case .deleteFailed:
            return "Failed to delete item from Keychain"
        case .itemNotFound:
            return "Item not found in Keychain"
        case .invalidData:
            return "Invalid data format"
        }
    }
}

/// Service class for handling secure storage using iOS Keychain
class KeychainService {
    /// Shared instance for singleton access
    static let shared = KeychainService()
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    /// Save a string value to Keychain
    /// - Parameters:
    ///   - key: The key to associate with the stored value
    ///   - value: The string value to store
    /// - Returns: Result indicating success or failure with error
    func save(key: String, value: String) -> Result<Void, KeychainError> {
        guard let data = value.data(using: .utf8) else {
            return .failure(.invalidData)
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        // First attempt to delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess ? .success(()) : .failure(.saveFailed)
    }
    
    /// Retrieve a string value from Keychain
    /// - Parameter key: The key associated with the stored value
    /// - Returns: Result containing the retrieved string or error
    func retrieve(key: String) -> Result<String, KeychainError> {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            return .failure(.itemNotFound)
        }
        
        guard status == errSecSuccess else {
            return .failure(.readFailed)
        }
        
        guard let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return .failure(.invalidData)
        }
        
        return .success(value)
    }
    
    /// Delete a value from Keychain
    /// - Parameter key: The key of the item to delete
    /// - Returns: Result indicating success or failure with error
    func delete(key: String) -> Result<Void, KeychainError> {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound 
            ? .success(()) 
            : .failure(.deleteFailed)
    }
}
