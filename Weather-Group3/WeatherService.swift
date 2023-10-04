//
//  WeatherService.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 10/4/23.
//

import Foundation

enum WeatherError: Error {
    case invalidURL
    case failTask
    case noData
    case failParsing
}

//struct WeatherService {
//    
//    let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
//    let apiKey = WeatherAPIService().apiKey
////    let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
//    
//    func getWeather(urlString: String, completion: @escaping (Result<DayWeather, WeatherError>) -> Void) {
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(.invalidURL))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if error != nil {
//                completion(.failure(.failTask))
//                return
//            }
//            
//            guard let data else {
//                
//                completion(.failure(.noData))
//                return
//            }
//            
//            parseWeatherJson(data: data) { result in
//                switch result {
//                case .failure(error):
//                    print(error)
//                    completion(.failure(error))
//                case .success(dayWeather):
//                    
//                }
//            }
//            
//            
//        }
//        
//        task.resume()
//    }
//    
//    func parseWeatherJson(data: Data, completion: @escaping (Result<DayWeather, WeatherError>) -> Void) {
//        let decoder = JSONDecoder()
//        do {
//            let dayWeather = try decoder.decode(DayWeather.self, from: data)
//            completion(.success(dayWeather))
//            
//        } catch {
//            completion(.failure(.failParsing))
//            return
//        }
//    }
//    
////    func parseSearchJSON(_ searchData: Data, completion: @escaping (Result<[DayWeather, WeatherError>) -> Void) {
//   //        let decode = JSONDecoder()
//   //
//   //        do {
//   //            let decodedData = try decode.decode(SearchData.self, from: searchData)
//   //            let searchItems = decodedData.items
//   //
//   //            let searchModels = searchItems.map { item in
//   //                return SearchModel(searchData: decodedData, searchItem: item)
//   //            }
//   //
//   //            completion(.success(searchModels))
//   //        } catch {
//   //            completion(.failure(.failParsing))
//   //        }
//   //    }
//}
