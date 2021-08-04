//
//  QR.swift
//  WSR-Asia
//
//  Created by ali on 8/4/21.
//

import Foundation

struct QR: Codable {
    var data: String?
    var success: Bool
    var error, message, title: String?
}
