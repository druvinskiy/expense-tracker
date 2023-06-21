//
//  User.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 6/18/23.
//

import Foundation

struct SignUp: Codable {
    let token: String
    let user: User
}

struct User: Codable, Equatable {
    let id: String?
    var password: String?
    let email: String?
}
