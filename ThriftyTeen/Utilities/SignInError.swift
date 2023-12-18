//
//  SignInError.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 9/27/23.
//

import Foundation

enum SignInError {
    case invalidEmail
    case invalidPassword
    
    var description: String {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address."
        case .invalidPassword:
            return "Please enter a valid password."
        }
    }
}
