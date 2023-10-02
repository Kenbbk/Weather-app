//
//  WeatherViewModel.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation
import UIKit

class WeatherViewModel {
    let tempUnit: String = "℃"
}

struct SomeDataModel {
    enum DataModelType: String {
        case one
        case two
        case three
        case four
        case five
    }
    
    let type: DataModelType
    
    var dayOfWeek: String {
        return type.rawValue
    }
    
    var day: String {
        switch type {
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        }
    }
}

struct Mocks {
    static func getDataSource() -> [SomeDataModel] {
        return [SomeDataModel(type: .one),
                SomeDataModel(type: .two),
                SomeDataModel(type: .three),
                SomeDataModel(type: .four),
                SomeDataModel(type: .five)]
    }
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
