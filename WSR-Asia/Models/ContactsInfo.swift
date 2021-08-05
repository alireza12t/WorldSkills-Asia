//
//  File.swift
//  WSR-Asia
//
//  Created by ali on 8/5/21.
//

import Foundation

struct ContactsInfo: Codable {
    let data: ContactsInfoData?
    let success: Bool
    var error, message, title: String?
    
    static func exampleData() -> ContactsInfoData {
        ContactsInfoData(cases: 0, vaccinated: 0)
    }
}

struct ContactsInfoData: Codable {
    var cases, vaccinated: Int
}
