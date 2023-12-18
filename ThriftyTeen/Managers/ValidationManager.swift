//
//  ValidationManager.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 9/16/23.
//

import Foundation

enum ValidationManager {
    static func isValidEmail(_ email: String) -> Bool {
        let detector = try? NSDataDetector(
            types: NSTextCheckingResult.CheckingType.link.rawValue
        )
        
        let range = NSRange(
            email.startIndex..<email.endIndex,
            in: email
        )
        
        let matches = detector?.matches(
            in: email,
            options: [],
            range: range
        )
        
        guard let match = matches?.first, matches?.count == 1 else {
            return false
        }
        
        guard match.url?.scheme == "mailto", match.range == range else {
            return false
        }
        
        return true
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return !password.isEmpty
    }
}
