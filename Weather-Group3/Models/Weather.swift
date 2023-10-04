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

struct WeatherData: Codable {
    let hourly: [HourlyWeather]?

    enum CodingKeys: String, CodingKey {
        case hourly = "hourly"
    }
}

struct HourlyWeather: Codable {
    let dt: Int
    let temp: Double
}

struct WeatherDescription {
    
//    let clearSky // 맑은 하늘을 나타냅니다.
//    let fewClouds // 구름이 조금 있는 하늘을 나타냅니다.
//    let scatteredClouds // 분산된 구름이 있는 하늘을 나타냅니다.
//    let brokenClouds // 끊어진 구름이 있는 하늘을 나타냅니다.
//    let overcastClouds // 흐린 하늘을 나타냅니다.
//    let lightRain // 가벼운 비가 내리는 날씨를 나타냅니다.
//    let moderateRain // 중간 정도의 강도의 비가 내리는 날씨를 나타냅니다.
//    let heavyRain // 많은 양의 비가 내리는 날씨를 나타냅니다.
//    let thunderstorm // 천둥 번개가 동반한 폭풍우를 나타냅니다.
//    let snow // 눈이 내리는 날씨를 나타냅니다.
//    let mist // 안개가 자욱한 날씨를 나타냅니다.
//    let haze // 연무가 있는 날씨를 나타냅니다.
//
//    let clear sky // 맑은 하늘을 나타냅니다.
//    let few clouds // 구름이 조금 있는 하늘을 나타냅니다.
//    let scattered clouds // 분산된 구름이 있는 하늘을 나타냅니다.
//    let broken clouds // 끊어진 구름이 있는 하늘을 나타냅니다.
//    let overcast clouds // 흐린 하늘을 나타냅니다.
//    let light rain // 가벼운 비가 내리는 날씨를 나타냅니다.
//    let moderate rain // 중간 정도의 강도의 비가 내리는 날씨를 나타냅니다.
//    let heavy rain // 많은 양의 비가 내리는 날씨를 나타냅니다.
//    let thunderstorm // 천둥 번개가 동반한 폭풍우를 나타냅니다.
//    let snow // 눈이 내리는 날씨를 나타냅니다.
//    let mist // 안개가 자욱한 날씨를 나타냅니다.
//    let haze // 연무가 있는 날씨를 나타냅니다.
}
