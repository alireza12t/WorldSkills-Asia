//
//  SymptomsHistory.swift
//  WSR-Asia
//
//  Created by ali on 8/3/21.
//

import Foundation

struct SymptomsHistory: Codable {
    var data: [SymptomsHistoryData]?
    var success: Bool
    var error, message, title: String?
}

struct SymptomsHistoryData: Codable {
    var date: String
    var probability_infection: Int
}
