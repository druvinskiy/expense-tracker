//
//  Category.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/24/23.
//

import Foundation

struct Category: Codable, Identifiable, Equatable, Hashable {
    let iconName: String?
    let user: User?
    let id: String?
    let name: String?
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
