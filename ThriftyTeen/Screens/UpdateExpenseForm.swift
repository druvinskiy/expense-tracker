//
//  UpdateExpenseForm.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 6/17/23.
//

import SwiftUI

struct UpdateExpenseForm: View {
    @State private var title = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var selectedCategory: Category?
    @State private var categories = [Category]()
    
    var dismissAction: ((Expense?) -> Void)
    let expense: Expense
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        return formatter
    }()
    
    init(expense: Expense, dismissAction: @escaping ((Expense?) -> Void)) {
        self.expense = expense
        _title = State(initialValue: expense.title)
        _amount = State(initialValue: currencyFormatter.string(from: NSDecimalNumber(decimal: expense.amount))!)
        
        _date = State(initialValue: expense.dateCreated)
        _selectedCategory = State(initialValue: expense.category)
        
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General Information")) {
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
                    VStack {
                        Button {
                            patchExpense()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Update")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .background(Color(UIColor.azureBlue))
                            .cornerRadius(5)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button {
                            deleteExpense()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Delete")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .background(Color(UIColor.scarletRed))
                            .cornerRadius(5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .navigationTitle("Update Expense")
            .navigationBarItems(trailing: Button {
                dismissAction(nil)
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
    
    func patchExpense() {
        guard let selectedCategory = selectedCategory,
              let intAmount = currencyFormatter.number(from: amount)?.decimalValue.convertToInt(currencyCode: "USD")
        else {
            return
        }
        
        let id = KeychainManager.shared.registrationData.user.id!
        let expense = PatchExpense(id: expense.id!, userID: id, categoryID: selectedCategory.id!, title: title, amount: intAmount, currencyCode: "USD", dateCreated: date)
        
        NetworkManager.shared.patchExpense(expense: expense) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedExpense):
                    self.dismissAction(updatedExpense)
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func deleteExpense() {
        NetworkManager.shared.deleteExpense(expense: expense) { error in
            DispatchQueue.main.async {
                self.dismissAction(expense)
            }
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
