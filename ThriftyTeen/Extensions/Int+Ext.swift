//
//  Int+Ext.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 6/19/23.
//

import Foundation

extension Int {
    func convertToDecimal(currencyCode: String) -> Decimal {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        
        return Decimal(self) / pow(10, formatter.minimumFractionDigits)
    }
}
