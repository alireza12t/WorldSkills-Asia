//
//  File.swift
//  WSR-Asia
//
//  Created by ali on 8/5/21.
//

import Foundation

struct UpdateSymptom: Codable {
    let data: String?
    let success: Bool
    var error, message, title: String?
}
