//
//  NetworkManager.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

import Foundation

class NetworkManager {
    enum HttpMethods: String {
        case POST, GET, PUT, DELETE
    }
    
    enum MIMEType: String {
        case JSON = "application/json"
    }
    
    enum HttpHeaders: String {
        case contentType = "Content-Type"
    }
    
    enum HTTPStatusCodes: Int {
        case success = 200
        
        static func ==(lhs: Int?, rhs: HTTPStatusCodes) -> Bool {
            guard let lhs else { return false }
            return lhs == rhs.rawValue
        }
    }
    
    static let shared = NetworkManager()
    private let baseUrl = "http://localhost:8080/api/v1/"
    
    private let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    func fetchExpenses(completed: @escaping (Result<[Expense], DRError>) -> Void) {
        let url = URL(string: baseUrl + "expenses")
        fetchGenericJSONData(url: url, completed: completed)
    }
    
    func fetchCategories(completed: @escaping (Result<[Category], DRError>) -> Void) {
        let url = URL(string: baseUrl + "categories")
        fetchGenericJSONData(url: url, completed: completed)
    }
    
    func postExpense(expense: ExpensePayload, completed: @escaping (DRError?) -> Void) {
        let url = URL(string: baseUrl + "expenses")
        postGenericJSONData(url: url, payload: expense, completed: completed)
    }
    
    func postCategory(category: CategoryPayload, completed: @escaping (DRError?) -> Void) {
        let url = URL(string: baseUrl + "categories")
        postGenericJSONData(url: url, payload: category, completed: completed)
    }
    
    private func postGenericJSONData<T: Encodable>(url: URL?, payload: T, completed: @escaping (DRError?) -> Void) {
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
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let data = try? encoder.encode(payload)
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == .success else {
            completed(.invalidResponse)
            return
        }
            
            completed(nil)
        }
        
        task.resume()
    }
    
    private func fetchGenericJSONData<T: Decodable>(url: URL?, completed: @escaping (Result<T, DRError>) -> Void) {
        guard let url = url else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
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
}
