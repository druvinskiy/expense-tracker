//
//  AddUpdateExpenseError.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 12/31/23.
//

import Foundation

enum AddUpdateExpenseError {
    case invalidExpenseTitle
    case invalidExpenseAmount
    case noCategorySelected
    case invalidCategoryName
    
    var description: String {
        switch self {
        case .invalidExpenseTitle:
            return "Please enter a title for your expense."
        case .invalidExpenseAmount:
            return "Please enter a valid amount for your expense."
        case .noCategorySelected:
            return "Please select a category or create a new one."
        case .invalidCategoryName:
            return "Please enter a name for your category."
        }
    }
}
