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
    @State private var date: Date
    @State private var categories = [Category]()
    @State private var selectedCategory: Category?
    @Environment(\.colorScheme) var colorScheme
    
    var dismissAction: (() -> Void)
    
    init(initialDate: Date = Date(), dismissAction: @escaping (() -> Void)) {
        _date = State(initialValue: initialDate)
        self.dismissAction = dismissAction
    }
    
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
                Section(header: Text("General information")) {
                    TextField("Title", text: $title)
                    
                    TextField("Amount", text: Binding(
                        get: {
                            return amount
                        },
                        set: { newValue in
                            if let decimal = Decimal(string: newValue), let formattedValue = currencyFormatter.string(from: NSDecimalNumber(decimal: decimal)) {
                                amount = formattedValue
                            } else {
                                amount = newValue
                            }
                        }
                    ))
                    .keyboardType(.decimalPad)
                    
                    DatePicker("Date",
                               selection: $date,
                               displayedComponents: .date)
                }
                
                Section(header: Text("Category")) {
                    ForEach(categories) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            HStack(spacing: 12) {
                                HStack {
                                    Image(category.iconName!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    
                                    Text(category.name!)
                                        .foregroundColor(Color(.label))
                                }
                                Spacer()
                                
                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                    .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                    
                    NavigationLink(destination: CategoriesListView(categories: $categories)) {
                        Text("New Category")
                    }
                }
                
                Section {
                    Button {
                        guard let selectedCategory = selectedCategory, let intAmount = currencyFormatter.number(from: amount)?.decimalValue.convertToInt(currencyCode: "USD")
                        else {
                            return
                        }

                        let user = KeychainManager.shared.registrationData.user

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
        .onAppear {
            fetchCategories()
        }
    }
    
    func fetchCategories() {
        NetworkManager.shared.fetchCategories { result in
            switch result {
            case .success(let categories):
                self.categories = categories
            case .failure(_):
                break
            }
        }
    }
}
