//
//  HighLowTempSerivce.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 10/5/23.
//

import Foundation

struct HighLowTempSerivce {
    
    func getHighLowTemp(threeHourList: [WeatherThreeHour]) -> (Double, Double) {
        let temperatrureList = threeHourList.map { $0.main.temp - 273.1 }
        return (temperatrureList.minAndMax()!)
    }
}
