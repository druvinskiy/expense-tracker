//
//  KeychainManager.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 6/18/23.
//

import Foundation

final class KeychainManager {
    static let shared = KeychainManager()
    
    var registrationData: RegistrationData! {
        return KeychainManager.shared.read(service: .bearerToken,
                                           account: .expenseTracker,
                                           type: RegistrationData.self)
    }
    
    enum Service {
        case bearerToken
        
        var value: String {
            switch self {
            case .bearerToken:
                return "bearer-token"
            }
        }
    }
    
    enum Account {
        case expenseTracker
        
        var value: String {
            switch self {
            case .expenseTracker:
                return "expense-tracker"
            }
        }
    }
    
    func save<T>(_ item: T, service: Service, account: Account) where T : Codable {
        do {
            // Encode as JSON data and save in keychain
            let data = try JSONEncoder().encode(item)
            save(data, service: service, account: account)
        } catch {
            assertionFailure("Fail to encode item for keychain: \(error)")
        }
    }
    
    func read<T>(service: Service, account: Account, type: T.Type) -> T? where T : Codable {
        // Read item data from keychain
        guard let data = read(service: service, account: account) else {
            return nil
        }
        
        // Decode JSON data to object
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
    
    func save(_ data: Data, service: Service, account: Account) {
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service.value,
            kSecAttrAccount: account.value,
        ] as [CFString : Any] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            // Print out the error
            print("Error: \(status)")
        }
    }
    
    func read(service: Service, account: Account) -> Data? {
        let query = [
            kSecAttrService: service.value,
            kSecAttrAccount: account.value,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(service: Service, account: Account) {
        let query = [
            kSecAttrService: service.value,
            kSecAttrAccount: account.value,
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any] as CFDictionary
        
        // Delete item from keychain
        let test = SecItemDelete(query)
        print(test)
    }
}
