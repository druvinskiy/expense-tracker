//
//  Expense.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

import Foundation

struct Expense {
    var category: Category
    let title: String
    let amount: Decimal
    let currencyCode: String
    let dateCreated: Date
    let id: String
    
    init(webExpense: FetchExpense) {
        self.category = webExpense.category
        self.title = webExpense.title
        self.currencyCode = webExpense.currencyCode
        self.amount = webExpense.amount.convertToDecimal(currencyCode: currencyCode)
        self.dateCreated = webExpense.dateCreated
        self.id = webExpense.id
    }
}

struct FetchExpense: Codable {
    var category: Category
    let title: String
    let amount: Int
    let currencyCode: String
    let dateCreated: Date
    let id: String
}

struct PatchExpense: Encodable {
    let id: String
    let userID: String
    let categoryID: String
    let title: String
    let amount: Int
    let currencyCode: String
    let dateCreated: Date
}

struct PostExpense: Encodable {
    var user: User
    let category: Category
    let title: String
    let amount: Int
    let currencyCode: String
    let dateCreated: Date
}
