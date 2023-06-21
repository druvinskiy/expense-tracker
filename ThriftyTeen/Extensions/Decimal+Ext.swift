//
//  Decimal+Ext.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 6/19/23.
//

import Foundation

extension Decimal {
    func convertToInt(currencyCode: String) -> Int {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        
        let decimalValue = self * pow(10, formatter.minimumFractionDigits)
        return NSDecimalNumber(decimal: decimalValue).intValue
    }
}
