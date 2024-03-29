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
    @State private var addUpdateExpenseError: AddUpdateExpenseError?
    
    var dismissAction: (() -> Void)
    let expense: Expense
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        return formatter
    }()
    
    enum FormField {
        case title, amount
    }
    
    @FocusState private var focusedField: FormField?
    
    init(expense: Expense, dismissAction: @escaping (() -> Void)) {
        self.expense = expense
        _title = State(initialValue: expense.title)
        _amount = State(initialValue: currencyFormatter.string(from: NSDecimalNumber(decimal: expense.amount))!)
        
        _date = State(initialValue: expense.dateCreated)
        _selectedCategory = State(initialValue: expense.category)
        
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    Section {
                        TextField("Title", text: $title)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .title)
                        
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
                        .focused($focusedField, equals: .amount)
                        
                        DatePicker("Date",
                                   selection: $date,
                                   displayedComponents: .date)
                    } header: {
                        Text("General Information")
                    }
                    
                    Section(header: Text("Category")) {
                        ForEach(categories) { category in
                            Button {
                                selectedCategory = category
                            } label: {
                                HStack(spacing: 12) {
                                    HStack {
                                        Image(category.iconName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                        
                                        Text(category.name)
                                            .foregroundColor(Color(.label))
                                    }
                                    Spacer()
                                    
                                    if selectedCategory == category {
                                        Image(systemName: "checkmark")
                                            .tint(Color(.azureBlue))
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                        
                        NavigationLink(destination: CategoriesListView(categories: $categories, selectedCategory: $selectedCategory)) {
                            Text("New Category")
                        }
                    }
                    
                    Section {
                        VStack {
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
                .onSubmit {
                    switch focusedField {
                    case .title:
                        focusedField = .amount
                    default:
                        focusedField = nil
                    }
                }
                .navigationTitle("Update \(expense.title)")
                .navigationBarItems(leading: Button {
                    dismissAction()
                } label: {
                    Text("Cancel")
                        .foregroundColor(Color(.label))
                }, trailing: Button {
                    patchExpense()
                } label: {
                    Text("Done")
                        .foregroundColor(Color(UIColor.azureBlue))
                })
            }
            .tint(.primary)
            .onAppear {
                fetchCategories()
            }
            
            if addUpdateExpenseError != nil {
                ExpenseAlertView(addExpenseError: $addUpdateExpenseError)
                    .background(Color.black.opacity(0.75).edgesIgnoringSafeArea(.all))
                    .zIndex(1)
            }
        }
    }
    
    func patchExpense() {
        guard let selectedCategory = selectedCategory else {
            return
        }
        
        withAnimation {
            
            guard !title.isEmpty else {
                addUpdateExpenseError = .invalidExpenseTitle
                return
            }
            
            guard let intAmount = currencyFormatter.number(from: amount)?.decimalValue.convertToInt(currencyCode: "USD") else {
                addUpdateExpenseError = .invalidExpenseAmount
                return
            }
            
            NetworkManager.shared.patchExpense(expenseId: expense.id,
                                               categoryId: selectedCategory.id,
                                               title: title,
                                               amount: intAmount,
                                               currencyCode: "USD",
                                               dateCreated: date)
            { error in
                guard error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismissAction()
                }
            }
        }
    }
    
    func deleteExpense() {
        NetworkManager.shared.deleteExpense(expense: expense) { error in
            DispatchQueue.main.async {
                self.dismissAction()
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
