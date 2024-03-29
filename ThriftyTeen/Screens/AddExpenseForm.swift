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
    @State private var addUpdateExpenseError: AddUpdateExpenseError?
    
    var dismissAction: ((Bool) -> Void)
    
    init(initialDate: Date = Date(), dismissAction: @escaping ((Bool) -> Void)) {
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
    
    enum FormField {
        case title, amount
    }
    
    @FocusState private var focusedField: FormField?
    
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
                        
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                            .tint(Color(UIColor.azureBlue))
                    } header: {
                        Text("General information")
                    }
                    
                    Section {
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
                    } header: {
                        Text("Category")
                    } footer: {
                        Button {
                            postExpense()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Create")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                        .padding(.top, 20)
                        .tint(Color(UIColor.azureBlue))
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
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
                .navigationTitle("Add Expense")
                .navigationBarItems(trailing: Button {
                    dismissAction(false)
                } label: {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                        .frame(width: 44, height: 44)
                        .foregroundColor(.primary)
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
    
    func fetchCategories() {
        NetworkManager.shared.fetchCategories { result in
            switch result {
            case .success(let categories):
                self.categories = categories
                self.selectedCategory = categories.first
            case .failure(_):
                break
            }
        }
    }
    
    func postExpense() {
        withAnimation {
            guard !title.isEmpty else {
                addUpdateExpenseError = .invalidExpenseTitle
                return
            }
            
            guard let intAmount = currencyFormatter.number(from: amount)?.decimalValue.convertToInt(currencyCode: "USD") else {
                addUpdateExpenseError = .invalidExpenseAmount
                return
            }
            
            guard let selectedCategory = selectedCategory else {
                addUpdateExpenseError = .noCategorySelected
                return
            }
            
            NetworkManager.shared.postExpense(category: selectedCategory, title: title, amount: intAmount, currencyCode: "USD", dateCreated: date) { error in
                DispatchQueue.main.async {
                    dismissAction(true)
                }
            }
        }
    }
}
