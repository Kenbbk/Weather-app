//
//  Weather.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation

// Decodable: A type that can decode itself from an external representation.
// JSON 데이터 디코딩
struct DayWeather: Decodable {
    let list: [List]
}

struct List: Decodable {
    let main: Main
    let weather: [Weather]
    let dt_txt: String
}

struct Main: Decodable {
    let temp: Double
}
 
struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
}
