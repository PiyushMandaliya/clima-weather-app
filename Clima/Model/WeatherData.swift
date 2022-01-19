//
//  WeatherData.swift
//  Clima
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let cod: Int
}

struct Main : Codable{
    let temp: Double
}

struct Weather: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Coord: Codable{
    let lon: Double
    let lat: Double
}

struct Wind: Codable{
    let speed: Float
    let deg: Int
    let gust: Double?
}

struct Clouds: Codable{
    let all: Int
}

struct Sys: Codable{
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}
