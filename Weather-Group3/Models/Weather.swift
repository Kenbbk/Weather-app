//
//  Weather.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation

// Decodable: A type that can decode itself from an external representation.
// JSON 데이터 디코딩
struct dayWeather: Decodable {
    let weather: [Weather]
        let main: Main
        let name: String
    // 날짜
    // 현재 온도
    // 날씨 iocn
    // 최고 온도
    // 최저 온도
    // 시간대별 온도
    // 일기 예보
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
