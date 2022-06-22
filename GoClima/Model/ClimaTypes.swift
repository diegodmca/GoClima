//
//  DadosClima.swift
//  GoClima
//
//  Created by Diego Carvalho on 20/06/22.
//

import Foundation

struct ClimaTypes: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable{
    let description: String
    let id: Int
}
