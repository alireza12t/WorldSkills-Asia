//
//  ValidationHelper.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import Foundation

class ValidationHelper {
    class func validateEmail(for email: String?) -> String? {
        if let email = email {
            if email.isEmpty {
                return "Enter Your Email!"
            } else {
                if email.contains("@") {
                    return nil
                } else {
                    return "Your Email is not Valid!"
                }
            }
        } else {
            return "Enter Your Email!"
        }
    }
}
