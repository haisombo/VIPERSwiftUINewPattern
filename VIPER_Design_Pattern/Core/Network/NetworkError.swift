//
//  NetworkError.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation
import Combine

// MARK: - Network Error Types
enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case noData
    case decodingError
    case encodingError
    case unauthorized
    case forbidden
    case notFound
    case serverError(Int)
    case noInternetConnection
    case timeout
    case cancelled
    case unknown(Error?)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .encodingError:
            return "Failed to encode request"
        case .unauthorized:
            return "Unauthorized access. Please login again"
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .serverError(let code):
            return "Server error: \(code)"
        case .noInternetConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .cancelled:
            return "Request was cancelled"
        case .unknown(let error):
            return error?.localizedDescription ?? "Unknown error occurred"
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.noData, .noData),
             (.decodingError, .decodingError),
             (.encodingError, .encodingError),
             (.unauthorized, .unauthorized),
             (.forbidden, .forbidden),
             (.notFound, .notFound),
             (.noInternetConnection, .noInternetConnection),
             (.timeout, .timeout),
             (.cancelled, .cancelled):
            return true
        case (.serverError(let code1), .serverError(let code2)):
            return code1 == code2
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
