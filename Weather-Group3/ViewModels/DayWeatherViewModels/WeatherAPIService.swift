//
//  WeatherAPIService.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation

// 에러 정의
enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

class WeatherAPIService {
    // .plist에서 API Key 가져오기
    var apiKey: String {
        get {
            // 생성한 .plist 파일 경로 불러오기
            guard let filePath = Bundle.main.path(forResource: "KeyList", ofType: "plist") else {
                fatalError("Couldn't find file 'KeyList.plist'.")
            }
            
            // .plist를 딕셔너리로 받아오기
            let plist = NSDictionary(contentsOfFile: filePath)
            
            // 딕셔너리에서 값 찾기
            guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
                fatalError("Couldn't find key 'OPENWEATHERMAP_KEY' in 'KeyList.plist'.")
            }
            return value
        }
    }
    
    func getWeather(completion: @escaping (Result<DayWeather, NetworkError>) -> Void) {
        
        // API 호출을 위한 URL
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=seoul&appid=\(apiKey)")
        guard let url = url else {
            return completion(.failure(.badUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            // Data 타입으로 받은 리턴을 디코드
            let weatherResponse = try? JSONDecoder().decode(DayWeather.self, from: data)
            
            // 성공
            if let weatherResponse = weatherResponse {
                print(weatherResponse)
                completion(.success(weatherResponse)) // 성공한 데이터 저장
            } else {
                completion(.failure(.decodingError))
            }
        }.resume() // 이 dataTask 시작
    }
    
    func getLocalWeather(url: String, completion: @escaping (Result<DayWeather, NetworkError>) -> Void) {
        
        // API 호출을 위한 URL
        let url = URL(string: url)
        guard let url = url else {
            return completion(.failure(.badUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            // Data 타입으로 받은 리턴을 디코드
            let weatherResponse = try? JSONDecoder().decode(DayWeather.self, from: data)
            
            // 성공
            if let weatherResponse = weatherResponse {
                print("현재 위치 날씨 정보 성공")
                print(weatherResponse)
                completion(.success(weatherResponse)) // 성공한 데이터 저장
            } else {
                print("현재 위치 날씨 정보 실패")
                completion(.failure(.decodingError))
            }
        }.resume() // 이 dataTask 시작
    }
}
