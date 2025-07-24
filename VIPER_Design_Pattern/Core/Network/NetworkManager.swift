//
//  NetworkManager.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation
import Combine
import CryptoKit
import os.log

// MARK: - 5. Summary of Benefits

/*
 CANCELLABLE BENEFITS:
 1. ⚡️ Performance: Cancel unnecessary requests
 2. 💾 Memory: Automatic cleanup, no leaks
 3. 🔋 Battery: Stop wasting resources
 4. 🎯 Accuracy: Prevent race conditions
 5. 🚀 UX: Faster, more responsive app
 6. 🛡 Safety: Prevent crashes from deallocated objects
 
 ERASETOANYPUBLISHER BENEFITS:
 1. 🔧 Flexibility: Change implementation freely
 2. 📝 Simplicity: Clean, readable API
 3. 🧪 Testability: Easy to mock and test
 4. 🔗 Composability: Combine publishers easily
 5. ⚡️ Compilation: Faster build times
 6. 🏗 Maintainability: Hide complex implementation
 
 TOGETHER THEY PROVIDE:
 - Professional, production-ready code
 - Better user experience
 - Easier maintenance
 - Fewer bugs
 - Better performance
 */

// MARK: - Network Manager Protocol
protocol NetworkManagerProtocol {
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError>
    func request(_ endpoint: APIEndpoint) -> AnyPublisher<Data, NetworkError>
    func uploadData(_ endpoint: APIEndpoint, data: Data, progressHandler: ((Double) -> Void)?) -> AnyPublisher<Data, NetworkError>
    func downloadData(_ endpoint: APIEndpoint, progressHandler: ((Double) -> Void)?) -> AnyPublisher<URL, NetworkError>
    
}
// MARK: - Network Manager Implementation
final class NetworkManager: NetworkManagerProtocol, @unchecked Sendable {

    static let shared           = NetworkManager()
    private let session         : URLSession
    private let sessionManager  : SessionManager
    private var cancellables    = Set<AnyCancellable>()
    
    private init(
        session         : URLSession = .shared,
        sessionManager  : SessionManager = .shared
    ) {
        self.session        = session
        self.sessionManager = sessionManager
    }
    
    // MARK: - Generic Request with Decodable Response
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        return createRequest(from: endpoint)
            .flatMap { request in
                self.performRequest(request)
            }
        
            .retry(12)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if error is DecodingError {
                    return .decodingError
                }
                return error as? NetworkError ?? .unknown(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Raw Data Request
    func request(_ endpoint: APIEndpoint) -> AnyPublisher<Data, NetworkError> {
        return createRequest(from: endpoint)
            .flatMap { request in
                self.performRequest(request)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Upload with Progress
    func uploadData(_ endpoint: APIEndpoint, data: Data, progressHandler: ((Double) -> Void)?) -> AnyPublisher<Data, NetworkError> {
        return createRequest(from: endpoint)
            .flatMap { request in
                self.performUpload(request, data: data, progressHandler: progressHandler)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Download with Progress
    func downloadData(_ endpoint: APIEndpoint, progressHandler: ((Double) -> Void)?) -> AnyPublisher<URL, NetworkError> {
        return createRequest(from: endpoint)
            .flatMap { request in
                self.performDownload(request, progressHandler: progressHandler)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    private func createRequest(from endpoint: APIEndpoint) -> AnyPublisher<URLRequest, NetworkError> {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = 30
        
        // Add default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add session token if available
        if let token = sessionManager.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add custom headers
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add body
        if let body = endpoint.body {
            request.httpBody = body
        } else if let parameters = endpoint.parameters,
                  endpoint.method != .get {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                return Fail(error: NetworkError.encodingError)
                    .eraseToAnyPublisher()
            }
        }
        
        // Add URL parameters for GET requests
        if endpoint.method == .get,
           let parameters = endpoint.parameters,
           var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
            if let urlWithParams = components.url {
                request.url = urlWithParams
            }
        }
        
        return Just(request)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    private func performRequest(_ request: URLRequest) -> AnyPublisher<Data, NetworkError> {
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    return data
                case 401:
                    throw NetworkError.unauthorized
                case 403:
                    throw NetworkError.forbidden
                case 404:
                    throw NetworkError.notFound
                case 500...599:
                    throw NetworkError.serverError(httpResponse.statusCode)
                default:
                    throw NetworkError.unknown(nil)
                }
            }
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                
                let nsError = error as NSError
                switch nsError.code {
                case NSURLErrorNotConnectedToInternet:
                    return .noInternetConnection
                case NSURLErrorTimedOut:
                    return .timeout
                case NSURLErrorCancelled:
                    return .cancelled
                default:
                    return .unknown(error)
                }
            }
            .handleEvents(receiveCompletion: { completion in
                if case .failure(let error) = completion,
                   error == .unauthorized {
                    // Handle token refresh or logout
//                    self.sessionManager.handleUnauthorized()
                }
            })
            .eraseToAnyPublisher()
    }
    
    private func performUpload(_ request: URLRequest, data: Data, progressHandler: ((Double) -> Void)?) -> AnyPublisher<Data, NetworkError> {
        var uploadRequest = request
        uploadRequest.httpBody = data
        
        return performRequest(uploadRequest)
    }
    
    private func performDownload(_ request: URLRequest, progressHandler: ((Double) -> Void)?) -> AnyPublisher<URL, NetworkError> {
        return session.downloadTaskPublisher(for: request)
            .tryMap { url, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.unknown(nil)
                }
                return url
            }
            .mapError { error in
                error as? NetworkError ?? .unknown(error)
            }
            .eraseToAnyPublisher()
    }
}


// MARK: - Session Manager
//@MainActor
final class SessionManager: ObservableObject, @unchecked Sendable {

    static let shared = SessionManager()
    
    @Published private(set) var isAuthenticated = false
    @Published private(set) var currentUser: User?
    
    private let keychain = KeychainManager()
    private var refreshTokenPublisher: AnyPublisher<String, NetworkError>?
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        loadSession()
    }
    
    // MARK: - Token Management
    func saveTokens(accessToken: String, refreshToken: String?) {
        keychain.save(accessToken, for: .accessToken)
        if let refreshToken = refreshToken {
            keychain.save(refreshToken, for: .refreshToken)
        }
        isAuthenticated = true
    }
    
    nonisolated func getAccessToken() -> String? {
        return keychain.get(.accessToken)
    }
    
    func getRefreshToken() -> String? {
        return keychain.get(.refreshToken)
    }
    
    func clearSession() {
        keychain.delete(.accessToken) // delete
        keychain.delete(.refreshToken)  // delete
        currentUser = nil // delete
        isAuthenticated = false // delete
    }
    
    // MARK: - User Session
    func saveUser(_ user: User) {
        currentUser = user
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }
    
    private func loadSession() {
        // Load user from UserDefaults
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
        }
        
        // Check if we have valid tokens
        isAuthenticated = getAccessToken() != nil
    }
    
    // MARK: - Token Refresh
    @MainActor
    func refreshAccessToken() -> AnyPublisher<String, NetworkError> {
        // Prevent multiple simultaneous refresh requests
        if let publisher = refreshTokenPublisher {
            return publisher
        }
        
        guard let refreshToken = getRefreshToken() else {
            return Fail(error: NetworkError.unauthorized)
                .eraseToAnyPublisher()
        }
        
        let endpoint = AuthEndpoint.refreshToken(refreshToken: refreshToken)
        
        let publisher = NetworkManager.shared
            .request(endpoint, responseType: TokenResponse.self)
            .map { response in
                self.saveTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
                return response.accessToken
            }
            .handleEvents(
                receiveCompletion: { _ in
                    self.refreshTokenPublisher = nil
                }
            )
            .share()
            .eraseToAnyPublisher()
        
        refreshTokenPublisher = publisher
        return publisher
    }
    
//    func handleUnauthorized() {
//        // Clear session and notify app to show login
//        clearSession()
//        NotificationCenter.default.post(name: .userSessionExpired, object: nil)
//    }
}

extension URLSession {
    func downloadTaskPublisher(for request: URLRequest) -> AnyPublisher<(URL, URLResponse), URLError> {
        return Future<(URL, URLResponse), URLError> { promise in
            let task = self.downloadTask(with: request) { url, response, error in
                if let error = error as? URLError {
                    promise(.failure(error))
                } else if let url = url, let response = response {
                    promise(.success((url, response)))
                } else {
                    promise(.failure(URLError(.unknown)))
                }
            }
            task.resume()
        }
        .eraseToAnyPublisher()
    }
}
