//
//  Country.swift
//  Milestone 13-15
//
//  Created by lz on 03/08/2024.
//

import Foundation

struct CountryList: Codable {
    let countries: [Country]
}

struct Country: Codable {
    let name: String
    let population: Int
    let size_km2: Double
    let capital: String
    let official_language: String
    let funFact: String
    let flag: String
}
