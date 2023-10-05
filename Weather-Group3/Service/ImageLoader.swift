//
//  ImageLoader.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 10/5/23.
//

import UIKit

struct ImageLoader {
    func loadImage(iconCode: String, completion: @escaping (Result<UIImage, WeatherError>) -> Void) {
        
        let iconURLString = "https://openweathermap.org/img/wn/\(iconCode).png"
        
        guard let iconURL = URL(string: iconURLString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: iconURL) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.failTask))
                print("데이터 가져오기 오류")
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(image))
        }
        // API 요청 시작
        task.resume()
    }
}
