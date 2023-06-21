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
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                
                TextField("Amount", text: Binding(
                    get: {
                        if let decimal = Decimal(string: amount), let formattedValue = currencyFormatter.string(from: NSDecimalNumber(decimal: decimal)) {
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
                    if let selectedCategory = selectedCategory {
                        HStack {
                            Image(selectedCategory.iconName!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            
                            Text(selectedCategory.name!)
                        }
                    } else {
                        Text("Select Category")
                    }
                }
                
                Button {
                    guard let selectedCategory = selectedCategory,
                          let intAmount = currencyFormatter.number(from: amount)?.decimalValue.convertToInt(currencyCode: "USD")
                    else {
                        return
                    }
                    
                    let user = KeychainManager.shared.signUp.user
                    
                    let expense = WebExpense(user: user, category: selectedCategory, title: title, amount: intAmount, currencyCode: "USD", dateCreated: date, id: nil)
                    
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
                    .background(Color(UIColor.azureBlue))
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
                    .foregroundColor(.primary)
            })
        }
    }
}
