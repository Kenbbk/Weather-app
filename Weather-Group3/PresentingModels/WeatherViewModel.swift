//
//  WeatherViewModel.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation
import UIKit

struct WeatherViewModel {
    let tempUnit: String = "℃"
    
    // 시간대별 온도를 저장할 곳
//    static var fiveDays: [String] = []
//    static var fiveDaysTemp: [FiveDayTemp] = []
    
    // 일별 데이터 저장.
    static var allDaysWeather: [OneDayWeather] = []
    // 1 2 3 4 5
}

struct FiveDayTemp {
    var time: [String]
    var icon: [String]
    var temp: [Double]
}

// 날짜 하루기준
struct OneDayWeather: Equatable, Hashable {
    let day: String // 날짜
    let highTemp: Double // 최고기온
    let lowTemp: Double // 최저기온
    let icon: String // 아이콘
    let timeWeather: [TimeWeather]// [시간별 날씨]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(day)
    }
}

// 시간별 날씨
struct TimeWeather: Equatable {
    let time: String // 시간
    let temp: Double // 기온
    let icon: String // 아이콘
}

// 현재 위치에 따른 날씨 정보
struct CurrentLocationForecast {
    let name: String
    let temp: Double
    let highTemp: Double
    let lowTemp: Double
    let description: String
}

struct DayDataModel {
    let dayOfWeek: String
    let day: String
}

struct Days {
    static func getDataSource() -> [DayDataModel] {
        var result: [DayDataModel] = []
        
        // 현재 날짜를 얻습니다.
        let currentDate = Date()

        // Calendar 객체를 생성합니다.
        let calendar = Calendar.current

        // 이후 5일의 날짜를 계산합니다.
        var futureDates: [Date] = []

        for day in 0..<5 {
            if let date = calendar.date(byAdding: .day, value: day, to: currentDate) {
                futureDates.append(date)
            }
        }

        // 날짜를 출력하거나 원하는 형식으로 포맷팅할 수 있습니다.
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "EEE"

        for date in futureDates {
            let formattedDay = dayFormatter.string(from: date)
            let formattedDayOfWeek = dayOfWeekFormatter.string(from: date)
            result.append(DayDataModel(dayOfWeek: formattedDayOfWeek, day: formattedDay))
        }
        
        return result
    }
}
