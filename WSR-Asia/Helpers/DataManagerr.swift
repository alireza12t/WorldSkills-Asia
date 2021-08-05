//
//  DataManagerr.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import Foundation

enum UserDefaultKeys: String {
    case token
    case name
    case login
    case id
    case contactDataUploaded
}

class DataManager {
    
    static var shared = DataManager()
    
    var token: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.token.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.token.rawValue)
        }
    }
    
    var contactDataUploaded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultKeys.contactDataUploaded.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.contactDataUploaded.rawValue)
        }
    }
    
    var name: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.name.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.name.rawValue)
        }
    }
    
    var id: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.id.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.id.rawValue)
        }
    }
    
    var login: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultKeys.login.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.login.rawValue)
        }
    }
}
