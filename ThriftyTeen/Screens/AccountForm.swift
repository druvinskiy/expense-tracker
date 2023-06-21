//
//  AccountForm.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 6/18/23.
//

import SwiftUI

struct AccountForm: View {
    enum Mode: String, CaseIterable, Identifiable {
        case signIn
        case signUp
        
        var id: String { self.rawValue }
        
        var displayText: String {
            switch self {
            case .signIn:
                return "Sign In"
            case .signUp:
                return "Sign Up"
            }
        }
    }
    
    @State private var mode = Mode.signIn
    @State private var email = ""
    @State private var password = ""
    @State private var isPresentingModal = false
    
    var body: some View {
//        NavigationView {
            Form {
                Section {
                    Picker("Select a color", selection: $mode) {
                        ForEach(Mode.allCases) { mode in
                            Text(mode.displayText).tag(mode)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Image("Illustration_SingIn_v3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .listRowBackground(Color.clear)
                }
                .listRowBackground(Color.clear)
                
                Section {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                }
                
                Section {
                    Button {
                        let user = User(id: nil, password: password, email: email)
                        
                        NetworkManager.shared.signUp(user: user) { error in
                            isPresentingModal = true
                        }
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
                    .fullScreenCover(isPresented: $isPresentingModal) {
                        YearsView()
                            .edgesIgnoringSafeArea(.all)
                    }
                }
                .listRowBackground(Color.clear)
//            }
            
//            .navigationTitle("Expense Tracker")
        }
    }
}

struct YearsView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: YearsViewController())
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
        
//        let vc = UIViewController()
//        vc.view.backgroundColor = .red
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<YearsView>) {}
}
