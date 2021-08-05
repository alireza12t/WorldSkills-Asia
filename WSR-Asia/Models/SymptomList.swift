//
//  SymptomList.swift
//  WSR-Asia
//
//  Created by ali on 8/5/21.
//

import Foundation

struct SymptomList: Codable {
    let data: [SymptomItem]?
    let success: Bool
    var error, message, title: String?
}

struct SymptomItem: Codable {
    var id: Int
    var title: String
}
