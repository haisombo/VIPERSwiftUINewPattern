//
//  UserServiceProtocol.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Combine

// MARK: - Network Service Example
protocol UserServiceProtocol {
    func login(email: String, password: String) -> AnyPublisher<User, NetworkError>
    func register(email: String, password: String, name: String) -> AnyPublisher<User, NetworkError>
    func logout() -> AnyPublisher<Void, NetworkError>
}


final class UserService: UserServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let sessionManager: SessionManager
    
    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        sessionManager: SessionManager = .shared
    ) {
        self.networkManager = networkManager
        self.sessionManager = sessionManager
    }
    
    func login(email: String, password: String) -> AnyPublisher<User, NetworkError> {
        let endpoint = AuthEndpoint.login(email: email, password: password)
        
        return networkManager.request(endpoint, responseType: LoginResponse.self)
            .map { response in
                self.sessionManager.saveTokens(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken
                )
                self.sessionManager.saveUser(response.user)
                return response.user
            }
            .eraseToAnyPublisher()
    }
    
    func register(email: String, password: String, name: String) -> AnyPublisher<User, NetworkError> {
        let endpoint = AuthEndpoint.register(email: email, password: password, name: name)
        
        return networkManager.request(endpoint, responseType: LoginResponse.self)
            .map { response in
                self.sessionManager.saveTokens(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken
                )
                self.sessionManager.saveUser(response.user)
                return response.user
            }
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, NetworkError> {
        let endpoint = AuthEndpoint.logout
        
        return networkManager.request(endpoint)
            .map { _ in
                self.sessionManager.clearSession()
                return ()
            }
            .eraseToAnyPublisher()
    }
}
