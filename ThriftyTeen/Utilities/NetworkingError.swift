//
//  NetworkingError.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

enum NetworkingError: String, Error {
    case invalidURL = "There was an issue connecting to the server. If this persists, please contact support."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
