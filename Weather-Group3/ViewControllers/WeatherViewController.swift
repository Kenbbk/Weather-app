//
//  WeatherViewController.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation
import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    lazy var weatherView: WeatherTitleView = {
        let view = WeatherTitleView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dateScrollView: DateScrollView = {
        let view = DateScrollView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tempGraphView: TempGraphView = {
        let view = TempGraphView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 받아온 데이터를 저장할 프로퍼티
    var weather: Weather?
    var main: Main?
    var name: String?
    // 현재 위치를 파악한 후 날씨 정보를 얻어오는 url
    var urlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        // Test: 특정 위치의 날씨정보 얻어오기
        setLocationManager()
    }
    
    // 위치 업데이트를 수신할 때 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // OpenWeatherMap API 엔드포인트 및 API 키 설정
            let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
            let apiKey = WeatherAPIService().apiKey
            let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
            
            // URLSession을 사용하여 데이터 가져오기
            if let url = URL(string: urlString) {
                let session = URLSession.shared
                let task = session.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("데이터를 가져오는 중 오류 발생: \(error)")
                    } else if let data = data {
                        // 데이터가 성공적으로 가져온 경우
                        do {
                            // JSON 디코딩
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                // 예보 데이터 확인
                                if let list = json["list"] as? [[String: Any]] {
                                    for forecast in list {
                                        if let dtTxt = forecast["dt_txt"] as? String,
                                           let main = forecast["main"] as? [String: Any],
                                           let temp = main["temp"] as? Double {
                                            // 날짜 및 시간대별 온도 출력
                                            print("main: \(main), Date/Time: \(dtTxt), Temperature: \(temp - 273.15) ℃")
                                        }
                                    }
                                }
                            }
                        } catch {
                            print("JSON 데이터 디코딩 중 오류 발생: \(error)")
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    // MARK: Helpers
    // MARK: 현재 위치 파악 함수.
    private func setLocationManager() {
        // 델리게이트를 설정하고,
        locationManager.delegate = self
        // 거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 사용 허용 알림
        locationManager.requestWhenInUseAuthorization()
        // 위치 사용을 허용하면 현재 위치 정보를 가져옴
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        else {
            print("위치 서비스 허용 off")
        }
    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        if let location = locations.first {
    //            // 위도와 경도 가져오기
    //            let latitude = location.coordinate.latitude
    //            let longitude = location.coordinate.longitude
    //            print("위치 업데이트!")
    //            print("위도 : \(latitude)")
    //            print("경도 : \(longitude)")
    //
    //            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(WeatherAPIService().apiKey)"
    //
    //            print("url String: \(urlString)")
    //            WeatherAPIService().getLocalWeather(url: urlString) { result in
    //                switch result {
    //                case .success(let weatherResponse):
    //                    DispatchQueue.main.async {
    //                        self.weather = weatherResponse.weather.first
    //                        self.main = weatherResponse.main
    //                        self.name = weatherResponse.name
    //                    }
    //                    print("main : \(weatherResponse.main)")
    //                    print("name : \(weatherResponse.name)")
    //                case .failure(_ ):
    //                    print("실패: error")
    //                }
    //            }
    //        }
    //    }
    
    // 위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: 위치 가져오기 실패")
    }
    
    func configure() {
        view.backgroundColor = .white
        
        setUI()
        setConstraint()
        insertDataSource() // scroll View
        setTemp()
        setForecast()
    }
    
    private func setUI() {
        view.addSubview(weatherView)
        view.addSubview(dateScrollView)
        view.addSubview(tempGraphView)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            //            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.heightAnchor.constraint(equalToConstant: 50),
            
            dateScrollView.topAnchor.constraint(equalTo: weatherView.bottomAnchor, constant: 20),
            dateScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dateScrollView.heightAnchor.constraint(equalToConstant: dateScrollView.scrollStackViewHeight), // 차후 설정 예정
            
            tempGraphView.topAnchor.constraint(equalTo: dateScrollView.bottomAnchor, constant: 20),
            tempGraphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tempGraphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tempGraphView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func insertDataSource() {
        //        dateScrollView.dataSource = Mocks.getDataSource()
        dateScrollView.dataSource = Days.getDataSource()
    }
    
    private func setTemp() {
        let currentTemp: String = "21"
        let highTemp: String = "25"
        let lowTemp: String = "17"
        
        tempGraphView.setTemp(currentTemp: currentTemp, highTemp: highTemp, lowTemp: lowTemp)
    }
    
    private func setForecast() {
        let forecast: String = "현재 기온은 21도이며 한때 흐린 상태입니다. 오후 12시~오후 1시에 맑은 상태가, 오후 2시에 대체로 흐린상태가 예상됩니다. 오늘 기온은 17도에서 25도사이입니다."
        
        tempGraphView.setForecast(forecast: forecast)
    }
}
