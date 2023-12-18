//
//  NetworkManager.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

import Foundation

class NetworkManager {
    enum HttpMethods: String {
        case POST, GET, PATCH, DELETE
    }
    
    enum MIMEType: String {
        case JSON = "application/json"
    }
    
    enum HttpHeaders: String {
        case contentType = "Content-Type"
        case authorization = "Authorization"
    }
    
    enum Token {
        case bearer(String)
        case basicAuth(String, String)
        
        var authorizationHeaderValue: String {
            switch self {
            case .bearer(let bearer):
                return "Bearer \(bearer)"
            case .basicAuth(let username, let password):
                let credentialData = "\(username):\(password)".data(using: .utf8)!
                let base64Credentials = credentialData.base64EncodedString()
                return "Basic \(base64Credentials)"
            }
        }
    }
    
    enum HTTPStatusCodes: Int {
        case success = 200
        case created = 201
        case accepted = 202
        
        static func ==(lhs: Int?, rhs: HTTPStatusCodes) -> Bool {
            guard let lhs else { return false }
            return lhs == rhs.rawValue
        }
    }
    
    static let shared = NetworkManager()
    private let baseUrl = "https://api.davidruvinskiy.com/"
    private let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter
    }()
    
    var registrationData: RegistrationData?
    
    // MARK: - Account
    func signUp(loginRequest: LoginRequest, completed: @escaping (NetworkingError?) -> Void) {
        let url = URL(string: baseUrl + "/auth/signup")
        
        guard let url = url else {
            completed(.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethods.POST.rawValue
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(self.dateFormatter)
        
        let data = try? encoder.encode(loginRequest)
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.unableToComplete)
                return
            }
            
            let response = response as! HTTPURLResponse
            
            guard response.statusCode == .success || response.statusCode == .created else {
                print(HTTPURLResponse.localizedString(forStatusCode: ))
                completed(.invalidResponse)
                return
            }
            
            guard let data = data else {
                completed(.invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(RegistrationData.self, from: data)
                
                KeychainManager.shared.save(decodedResponse, service: .bearerToken, account: .expenseTracker)
                self.registrationData = decodedResponse
                
                completed(nil)
            } catch {
                completed(.invalidData)
            }
        }
        
        task.resume()
    }
    
    func signIn(email: String, password: String, completed: @escaping (NetworkingError?) -> Void) {
        let url = URL(string: baseUrl + "auth/signin")
        
        guard let url = url else {
            completed(.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethods.POST.rawValue
        request.addValue(Token.basicAuth(email, password).authorizationHeaderValue, forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.unableToComplete)
                return
            }
            
            let response = response as! HTTPURLResponse
            
            guard response.statusCode == .success || response.statusCode == .created else {
                print(HTTPURLResponse.localizedString(forStatusCode: ))
                completed(.invalidResponse)
                return
            }
            
            guard let data = data else {
                completed(.invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(RegistrationData.self, from: data)
                
                KeychainManager.shared.save(decodedResponse, service: .bearerToken, account: .expenseTracker)
                self.registrationData = decodedResponse
                
                completed(nil)
            } catch {
                completed(.invalidData)
            }
        }
        
        task.resume()
    }
    
    func signOut(completed: @escaping (NetworkingError?) -> Void) {
        let url = URL(string: baseUrl + "auth/signout")
        
        guard let url = url else {
            completed(.invalidURL)
            return
        }
        
        guard let token = registrationData?.token else {
            completed(.unableToComplete)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethods.POST.rawValue
        request.addValue(Token.bearer(token).authorizationHeaderValue, forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.unableToComplete)
                return
            }
            
            let response = response as! HTTPURLResponse
            
            guard response.statusCode == .success || response.statusCode == .created else {
                print(HTTPURLResponse.localizedString(forStatusCode: ))
                completed(.invalidResponse)
                return
            }
            
            KeychainManager.shared.delete(service: .bearerToken, account: .expenseTracker)
            self.registrationData = nil
            
            completed(nil)
        }
        
        task.resume()
    }
    
    // MARK: - Expenses
    func fetchExpenses(completed: @escaping (Result<[Expense], NetworkingError>) -> Void) {
        let url = URL(string: baseUrl + "expenses")
        
        fetchGenericJSONData(url: url) { (result: Result<[FetchExpense], NetworkingError>) in
            switch result {
            case .success(let webExpenses):
                completed(.success(webExpenses.map({ Expense(webExpense: $0) })))
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    func postExpense(category: Category,
                     title: String,
                     amount: Int,
                     currencyCode: String,
                     dateCreated: Date,
                     completed: @escaping (NetworkingError?) -> Void) {
        
        guard let user = registrationData?.user else {
            completed(.unableToComplete)
            return
        }
        
        let url = URL(string: baseUrl + "expenses")
        let expense = PostExpense(user: user, category: category, title: title, amount: amount, currencyCode: currencyCode, dateCreated: dateCreated)
        
        postGenericJSONData(url: url, payload: expense, completed: completed)
    }
    
    func patchExpense(expenseId: String,
                      categoryId: String,
                      title: String,
                      amount: Int,
                      currencyCode: String,
                      dateCreated: Date,
                      completed: @escaping (NetworkingError?) -> Void) {
        guard let user = registrationData?.user else {
            completed(.unableToComplete)
            return
        }
        
        let url = URL(string: baseUrl + "expenses")
        let expense = PatchExpense(id: expenseId,
                                        userID: user.id,
                                        categoryID: categoryId,
                                        title: title,
                                        amount: amount,
                                        currencyCode: currencyCode,
                                        dateCreated: dateCreated)
        
        patchGenericJSONData(url: url, payload: expense, completed: completed)
    }
    
    func deleteExpense(expense: Expense, completed: @escaping (NetworkingError?) -> Void) {
        let url = URL(string: baseUrl + "expenses/\(expense.id)")
        delete(url: url, completed: completed)
    }
    
    // MARK: - Categories
    func fetchCategories(completed: @escaping (Result<[Category], NetworkingError>) -> Void) {
        let url = URL(string: baseUrl + "categories")
        fetchGenericJSONData(url: url, completed: completed)
    }
    
    func postCategory(iconName: String, name: String, completed: @escaping (NetworkingError?) -> Void) {
        guard let user = registrationData?.user else {
            completed(.unableToComplete)
            return
        }
        
        let url = URL(string: baseUrl + "categories")
        let category = PostCategory(user: user, iconName: iconName, name: name)
        
        postGenericJSONData(url: url, payload: category, completed: completed)
    }
    
    // MARK: - Generic Functions
    private func postGenericJSONData<T: Encodable>(url: URL?, payload: T, completed: @escaping (NetworkingError?) -> Void) {
        guard let url = url else {
            completed(.invalidURL)
            return
        }
        
        // TODO: Create a different error for this
        guard let token = registrationData?.token else {
            completed(.unableToComplete)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethods.POST.rawValue
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        request.addValue(Token.bearer(token).authorizationHeaderValue, forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(self.dateFormatter)
        //        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let data = try? encoder.encode(payload)
        request.httpBody = data
        
        // Convert to a string and print
        if let JSONString = String(data: data!, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.unableToComplete)
                return
            }
            
            let response = response as! HTTPURLResponse
            
            guard response.statusCode == .success || response.statusCode == .created else {
                print(HTTPURLResponse.localizedString(forStatusCode: ))
                completed(.invalidResponse)
                return
            }
            
            completed(nil)
        }
        
        task.resume()
    }
    
    private func postGenericJSONData<T: Encodable, U: Decodable>(url: URL?, payload: T, completed: @escaping (Result<U, NetworkingError>) -> Void) {
        guard let url = url else {
            completed(.failure(.invalidURL))
            return
        }
        
        // TODO: Create a different error for this
        guard let token = registrationData?.token else {
            completed(.failure(.unableToComplete))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethods.POST.rawValue
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        request.addValue(Token.bearer(token).authorizationHeaderValue, forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(self.dateFormatter)
        
        let data = try? encoder.encode(payload)
        request.httpBody = data
        
        // Convert to a string and print
        if let JSONString = String(data: data!, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            let response = response as! HTTPURLResponse
            
            guard response.statusCode == .success || response.statusCode == .created else {
                print(HTTPURLResponse.localizedString(forStatusCode: ))
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                
                let decodedResponse = try decoder.decode(U.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
            }
            
        }
        
        task.resume()
    }
    
    private func delete(url: URL?, completed: @escaping (NetworkingError?) -> Void) {
        guard let url = url else {
            completed(.invalidURL)
            return
        }
        
        // TODO: Create a different error for this
        guard let token = registrationData?.token else {
            completed(.unableToComplete)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethods.DELETE.rawValue
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        request.addValue(Token.bearer(token).authorizationHeaderValue, forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.unableToComplete)
                return
            }
            
            let response = response as! HTTPURLResponse
            
            guard response.statusCode == .success || response.statusCode == .accepted else {
                print(HTTPURLResponse.localizedString(forStatusCode: ))
                completed(.invalidResponse)
                return
            }
            
            completed(nil)
        }
        
        task.resume()
    }
    
    private func fetchGenericJSONData<T: Decodable>(url: URL?, completed: @escaping (Result<T, NetworkingError>) -> Void) {
        guard let url = url else {
            completed(.failure(.invalidURL))
            return
        }
        
        // TODO: Create a different error for this
        guard let token = registrationData?.token else {
            completed(.failure(.unableToComplete))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.GET.rawValue
        request.addValue(Token.bearer(token).authorizationHeaderValue, forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == .success else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                
                let decodedResponse = try decoder.decode(T.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    private func patchGenericJSONData<T: Encodable>(url: URL?, payload: T, completed: @escaping (NetworkingError?) -> Void) {
        guard let url = url else {
            completed(.invalidURL)
            return
        }
        
        // TODO: Create a different error for this
        guard let token = registrationData?.token else {
            completed(.unableToComplete)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethods.PATCH.rawValue
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        request.addValue(Token.bearer(token).authorizationHeaderValue, forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(self.dateFormatter)
        
        let data = try? encoder.encode(payload)
        request.httpBody = data
        
        // Convert to a string and print
        if let JSONString = String(data: data!, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.unableToComplete)
                return
            }
            
            let response = response as! HTTPURLResponse
            
            guard response.statusCode == .accepted || response.statusCode == .created else {
                print(HTTPURLResponse.localizedString(forStatusCode: ))
                completed(.invalidResponse)
                return
            }
            
            guard let data = data else {
                completed(.invalidData)
                return
            }
            
            if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
            
//            do {
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
//
//                let decodedResponse = try decoder.decode(U.self, from: data)
//                completed(.success(decodedResponse))
//            } catch {
//                completed(.failure(.invalidData))
//            }
            
            completed(nil)
        }
        
        task.resume()
    }
}
