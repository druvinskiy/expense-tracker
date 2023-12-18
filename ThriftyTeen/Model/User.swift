//
//  User.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 6/18/23.
//

import Foundation

struct RegistrationData: Codable {
    let token: String
    let user: User
}

struct User: Codable, Equatable {
    let id: String
    let email: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}
