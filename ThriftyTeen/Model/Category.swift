//
//  Category.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/24/23.
//

import Foundation

struct CategoryPayload: Codable {
    let title: String
}

struct Category: Codable, Identifiable, Equatable {
    let id, title: String
}
