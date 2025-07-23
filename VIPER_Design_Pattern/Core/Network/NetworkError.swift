//
//  NetworkError.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation

enum NetworkError: Error, LocalizedError, Sendable {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unauthorized
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let message):
            return message
        case .unauthorized:
            return "Unauthorized access"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
