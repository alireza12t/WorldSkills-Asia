//
//  CovidStats.swift
//  WSR-Asia
//
//  Created by ali on 8/4/21.
//

import Foundation

struct CoivdStats: Codable {
    let data: CoivdStatsData?
    let success: Bool
    var error, message, title: String?
    
    static func exampleData() -> CoivdStatsData {
        CoivdStatsData(world: CurrentCity(infected: 1, death: 1, recovered: 1, vaccinated: 1, recovered_adults: 1, recoveredYoung: 1), current_city: CurrentCity(infected: 0, death: 0, recovered: 0, vaccinated: 0, recovered_adults: 0, recoveredYoung: 0))
    }
}

struct CoivdStatsData: Codable {
    let world, current_city: CurrentCity
}

struct CurrentCity: Codable {
    let infected, death, recovered, vaccinated: Int
    let recovered_adults, recoveredYoung: Int
}
