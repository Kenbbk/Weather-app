//
//  LocationManager.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation
import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    // 위치 관리자
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // 위치 업데이트를 수신할 때 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> String {
        var urlString = ""
        if let location = locations.first {
            // 위도와 경도 가져오기
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // OpenWeatherMap API 요청 URL 생성
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(WeatherAPIService().apiKey)"
        }
        return urlString
    }
}
