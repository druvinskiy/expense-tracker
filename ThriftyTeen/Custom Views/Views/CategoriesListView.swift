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
    @State private var name = ""
    @State private var selectedIndex = 0
    
    let columns: [GridItem] = [GridItem(.fixed(100)),
                               GridItem(.fixed(100)),
                               GridItem(.fixed(100)),
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Select a category")) {
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
            }
            
            Section(header: Text("Create a category")) {
                TextField("Title", text: $name)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(0..<50) { index in
                            if index == selectedIndex {
                                Image("Icon\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 40)
                                    .onTapGesture {
                                        selectedIndex = index
                                    }
                                    .background(Color(UIColor.smokyCharcoal.withAlphaComponent(0.2))
                                        .frame(width: 75, height: 75)
                                        .cornerRadius(5))
                            } else {
                                Image("Icon\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 40)
                                    .onTapGesture {
                                        selectedIndex = index
                                    }
                            }
                        }
                    }
                    .padding([.top, .bottom], 20)
                }
                .frame(height: 260)
                
                Button {
                    let user = KeychainManager.shared.signUp.user
                    
                    let category = Category(iconName: "Icon\(selectedIndex)", user: user, id: nil, name: name)
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
                    .background(Color(UIColor.azureBlue))
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
                name = ""
            case .failure(_):
                break
            }
        }
    }
}
