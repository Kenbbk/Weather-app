//
//  WeatherProvider.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/10/05.
//

import Foundation

class WeatherProvider {
    
    func getTimeWeathers(dayWeather: DayWeather) -> [TimeWeather] {
        let list = dayWeather.list
        
        let timeWeathers = list.map { weather in
            let time = weather.dt_txt.convertToTimeString()
            
            
return TimeWeather(time: time, temp: weather.main.temp - 273.15, icon: weather.weather[0].icon)
        }
        
        return timeWeathers
    }
    
    func getWeathers(dayWeather: DayWeather) -> [OneDayWeather] {
        var fiveDays: [String] = []
        var fiveDaysTemp: [FiveDayTemp] = []
        
        var oneDayWeathers: [OneDayWeather] = []
        
        for forecast in dayWeather.list {
            // 온도 저장.
            let tempChange = forecast.main.temp // - 273.15
            
            // 공백 기준으로 문자열 자르기 ex) 2023-10-06 12:00:00 -> 2023-10-06, 12:00:00
            let parts = forecast.dt_txt.split(separator: " ")
            let day = String(parts[0])
            
            let timeParts = String(parts[1]).split(separator: ":00")
            let time = "\(timeParts[0]) 시"
            
            // 년월일 저장
            if !fiveDays.contains(day) {
                fiveDays.append(day)
                // WeatherViewModel.fiveDaysTemp에 온도를 저장하는 빈 FivedayTemp 구조체 형식을 추가해준다.
                fiveDaysTemp.append(FiveDayTemp(time: [], icon: [], temp: []))
            }
            
            // 입력받은 일의 수를 파악하여(fiveDays) 시간대별 온도를 저장할 배열(fiveDaysTemp)에 index값으로 사용함.
            if !fiveDaysTemp[fiveDays.count-1].time.contains(time) {
                fiveDaysTemp[fiveDays.count-1].time.append(time)
                fiveDaysTemp[fiveDays.count-1].icon.append(forecast.weather.first!.icon)
                fiveDaysTemp[fiveDays.count-1].temp.append(tempChange)
            }
        }
        
        for index in 0..<fiveDaysTemp.count {
            var timeWeather: [TimeWeather] = []
            
            for timeIndex in 0..<fiveDaysTemp[index].time.count {
                timeWeather.append(TimeWeather(time: fiveDaysTemp[index].time[timeIndex], temp: fiveDaysTemp[index].temp[timeIndex], icon: fiveDaysTemp[index].icon[timeIndex]))
            }
            
            let oneDayWeather: OneDayWeather = OneDayWeather(day: fiveDays[index], highTemp: fiveDaysTemp[index].temp.max()!, lowTemp: fiveDaysTemp[index].temp.min()!, icon: fiveDaysTemp[index].icon.first!, timeWeather: timeWeather)
            
            oneDayWeathers.append(oneDayWeather)
        }
        
        return oneDayWeathers
    }
    
    // 현재 위치의 날씨값을 얻음.
    func getCityInfo(dayWeather: DayWeather, oneDayWeather: OneDayWeather) -> CurrentLocationForecast {
        return CurrentLocationForecast(name: dayWeather.city.name, temp: oneDayWeather.timeWeather[0].temp, highTemp: oneDayWeather.highTemp, lowTemp: oneDayWeather.lowTemp, description: dayWeather.list[0].weather[0].description)
    }
}
