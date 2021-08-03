//
//  SignIn.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import Foundation

struct SignIn: Codable {
    var success: Bool
    var error, message, title: String?
    var data: SignInData?
}

struct SignInData: Codable {
    var id, login, name, token: String
}
