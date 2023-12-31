//
//  CategoriesListView.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/24/23.
//

import SwiftUI

struct CategoriesListView: View {
    @State private var name = ""
    @State private var selectedIndex = 0
    @State private var addUpdateExpenseError: AddUpdateExpenseError?
    
    @Binding var categories: [Category]
    @Binding var selectedCategory: Category?
    
    @Environment(\.presentationMode) var presentationMode
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 60)),
        //        GridItem(.adaptive(minimum: 60)),
        //        GridItem(.adaptive(minimum: 60)),
    ]
    
    enum CreateCategoryError {
        static let invalidName = "Please enter a valid name for your category."
    }
    
    var body: some View {
        ZStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                }
                
                Section(header: Text("Select an icon")) {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(0..<50) { index in
                                Image("Icon\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 40)
                                    .onTapGesture {
                                        selectedIndex = index
                                    }
                                    .background((index == selectedIndex ? Color(UIColor.smokyCharcoal.withAlphaComponent(0.4))
                                                 : .clear)
                                        .frame(width: 62, height: 75)
                                        .cornerRadius(5))
                            }
                        }
                        .padding([.top, .bottom], 20)
                    }
                    .frame(height: 260)
                }
                
                Button {
                    postCategory()
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
            .navigationTitle("Create Category")
            .navigationBarTitleDisplayMode(.inline)
            
            if addUpdateExpenseError != nil {
                ExpenseAlertView(addExpenseError: $addUpdateExpenseError)
                    .background(Color.black.opacity(0.75).edgesIgnoringSafeArea(.all))
                    .zIndex(1)
            }
        }
    }
    
    func postCategory() {
        withAnimation {
            guard !name.isEmpty else {
                addUpdateExpenseError = .invalidCategoryName
                return
            }
            
            
            NetworkManager.shared.postCategory(iconName: "Icon\(selectedIndex)", name: name) { result in
                switch result {
                case .success(let category):
                    selectedCategory = category
                case .failure(_):
                    break
                }
                
                fetchCategories()
            }
        }
    }
    
    func fetchCategories() {
        NetworkManager.shared.fetchCategories { result in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let categories):
                    self.categories = categories
                    self.presentationMode.wrappedValue.dismiss()
                case .failure(_):
                    break
                }
            }
        }
    }
}
