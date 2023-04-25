//
//  CategoriesListView.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/24/23.
//

import SwiftUI

struct CategoriesListView: View {
    @Binding var selectedCategory: Category?
    @State private var categories = [Category]()
    @State private var title = ""
    
    var body: some View {
        Form {
            Section(header: Text("Select a category")) {
                ForEach(categories) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        HStack(spacing: 12) {
                            Text(category.title)
                                .foregroundColor(Color(.label))
                            Spacer()
                            
                            if selectedCategory == category {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Create a category")) {
                TextField("Title", text: $title)
                
                Button {
                    let category = CategoryPayload(title: title)
                    NetworkManager.shared.postCategory(category: category) { error in
                        getCategories()
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
        }
        .onAppear {
            getCategories()
        }
    }
    
    func getCategories() {
        NetworkManager.shared.fetchCategories { result in
            switch result {
            case .success(let categories):
                self.categories = categories
                title = ""
            case .failure(_):
                break
            }
        }
    }
}
