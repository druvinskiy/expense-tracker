//
//  AddExpenseForm.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/20/23.
//

import SwiftUI

struct AddExpenseForm: View {
    @State private var title = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var selectedCategory: Category?
    
    var dismissAction: (() -> Void)
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                
                TextField("Amount", text: Binding(
                    get: {
                        if let double = Double(amount), let formattedValue = currencyFormatter.string(from: NSNumber(value: double)) {
                            return formattedValue
                        } else {
                            return self.amount
                        }
                    },
                    set: { newValue in
                        self.amount = newValue
                    }
                ))
                .keyboardType(.decimalPad)
                
                DatePicker("Date",
                           selection: $date,
                           displayedComponents: .date)
                
                NavigationLink(destination: CategoriesListView(selectedCategory: $selectedCategory)
                    .navigationTitle("Categories")
                ) {
                    Text(selectedCategory != nil ? selectedCategory!.title : "Select category")
                }
                
                Button {
                    guard let selectedCategory = selectedCategory else {
                        return
                    }
                    
                    var expense: ExpensePayload
                    
                    if let double = Double(amount) {
                        expense = ExpensePayload(title: title, category: selectedCategory, amount: double, date: date)
                    } else if let number = currencyFormatter.number(from: amount) {
                        expense = ExpensePayload(title: title, category: selectedCategory, amount: number.doubleValue, date: date)
                    } else {
                        return
                    }
                    
                    NetworkManager.shared.postExpense(expense: expense) { error in
                        DispatchQueue.main.async {
                            dismissAction()
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Create")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(5)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle("Add Expense")
            .navigationBarItems(trailing: Button {
                dismissAction()
            } label: {
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .frame(width: 44, height: 44)
                    .foregroundColor(.black)
            })
        }
    }
}
