//
//  UserDefaultsManager.swift
//  VIPER_Design_Pattern
//
//  Created by Sombo Mobile R&D on 23/7/25.
//

import Foundation

actor UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
        static let userEmail = "userEmail"
        static let userName = "userName"
        static let userId = "userId"
    }
    
    private init() {}
    
    var isLoggedIn: Bool {
        get { userDefaults.bool(forKey: Keys.isLoggedIn) }
    }
    
    func setLoggedIn(_ value: Bool) {
        userDefaults.set(value, forKey: Keys.isLoggedIn)
    }
    
    var userEmail: String? {
        get { userDefaults.string(forKey: Keys.userEmail) }
    }
    
    func setUserEmail(_ value: String?) {
        userDefaults.set(value, forKey: Keys.userEmail)
    }
    
    var userName: String? {
        get { userDefaults.string(forKey: Keys.userName) }
    }
    
    func setUserName(_ value: String?) {
        userDefaults.set(value, forKey: Keys.userName)
    }
    
    var userId: String? {
        get { userDefaults.string(forKey: Keys.userId) }
    }
    
    func setUserId(_ value: String?) {
        userDefaults.set(value, forKey: Keys.userId)
    }
    
    func clearAll() {
        userDefaults.removeObject(forKey: Keys.isLoggedIn)
        userDefaults.removeObject(forKey: Keys.userEmail)
        userDefaults.removeObject(forKey: Keys.userName)
        userDefaults.removeObject(forKey: Keys.userId)
    }
}
