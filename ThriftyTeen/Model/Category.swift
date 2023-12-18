//
//  Category.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/24/23.
//

import Foundation

struct Category: Codable, Identifiable, Equatable, Hashable {
    let iconName: String
    let id: String
    let name: String
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct PostCategory: Encodable {
    let user: User
    let iconName: String
    let name: String
}
