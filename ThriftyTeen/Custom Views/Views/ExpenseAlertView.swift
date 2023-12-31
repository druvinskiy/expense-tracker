//
//  ExpenseAlertView.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 12/31/23.
//

import SwiftUI

struct ExpenseAlertView: UIViewControllerRepresentable {
    @Binding var addExpenseError: AddUpdateExpenseError?
    
    typealias UIViewControllerType = ExpenseAlertViewController
    
    func makeUIViewController(context: Context) -> ExpenseAlertViewController {
        return ExpenseAlertViewController(message: addExpenseError?.description ?? "") {
            withAnimation {
                self.addExpenseError = nil
            }
        }
    }
    
    func updateUIViewController(_ uiViewController: ExpenseAlertViewController, context: Context) { }
}
