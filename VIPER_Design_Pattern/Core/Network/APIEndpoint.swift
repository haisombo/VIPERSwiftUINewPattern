//
//  APIEndpoint.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//
import Foundation

enum HTTPMethod: String {
    
    case get        = "GET"
    case post       = "POST"
    case put        = "PUT"
    case patch      = "PATCH"
    case delete     = "DELETE"
}

// MARK: - API Endpoint Protocol
protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
}

enum AuthEndpoint: APIEndpoint {
    
    case login(email: String, password: String)
    case register(email: String, password: String, name: String)
    case refreshToken(refreshToken: String)
    case logout
    
    var baseURL: String {
        return "https://api.example.com"
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .refreshToken:
            return "/auth/refresh"
        case .logout:
            return "/auth/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .register, .refreshToken:
            return .post
        case .logout:
            return .delete
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .register(let email, let password, let name):
            return ["email": email, "password": password, "name": name]
        case .refreshToken(let refreshToken):
            return ["refreshToken": refreshToken]
        case .logout:
            return nil
        }
    }
    
    var body: Data? {
        if let parameters = parameters {
            return try? JSONSerialization.data(withJSONObject: parameters)
        }
        return nil
    }
}
