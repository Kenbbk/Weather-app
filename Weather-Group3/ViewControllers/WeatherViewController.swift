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
    // MARK: View 목록
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
    
    // MARK: - Properties
    var section: Int?
    var row: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("section: \(section)")
        print("row: \(row)")
        configure()
    }
    
    // MARK: Helpers
    
    func configure() {
        view.backgroundColor = .white
        
        setUI()
        setConstraint()
        insertDataSource() // scroll View
        
        setDate()
        setTemp()
        setLineChart()
        setForecast()
    }
    
    private func setUI() {
        weatherView.delegate = self
        
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
        dateScrollView.dataSource = Days.getDataSource()
    }
    
    private func setDate() {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-mm-dd"
        var inputDate: Date = Date()
        if section == 0 {
            inputDate = dateFormatter.date(from: WeatherViewModel.fiveDays[0])!
        } else if section == 1 {
            inputDate = dateFormatter.date(from: WeatherViewModel.fiveDays[row!])!
        }
        
        dateFormatter.dateFormat = "YYYY년 mm월 dd일 EEE요일"
        
        let outputDate = dateFormatter.string(from: inputDate)
        
        let selectedDate: String = outputDate
        print("selectedDate : \(selectedDate)")
        
        tempGraphView.setDate(date: selectedDate)
    }
    
    private func setTemp() {
        
        let formattedCurrentTemp: String = String(format: "%.1f", WeatherViewModel.fiveDaysTemp[row ?? 0].temp[0])
        let formattedHighTemp: String = String(format: "%.1f", WeatherViewModel.fiveDaysTemp[row ?? 0].temp.max()!)
        let formattedLowTemp: String = String(format: "%.1f", WeatherViewModel.fiveDaysTemp[row ?? 0].temp.min()!)
        
        let currentTemp: String = formattedCurrentTemp
        let highTemp: String = formattedHighTemp
        let lowTemp: String = formattedLowTemp
        
        tempGraphView.setTemp(currentTemp: currentTemp, highTemp: highTemp, lowTemp: lowTemp)
    }
    
    private func setLineChart() {
        if section == 0 {
            tempGraphView.setLineChart(temp: WeatherViewModel.fiveDaysTemp[0].temp, time: WeatherViewModel.fiveDaysTemp[0].time)
        } else if section == 1 {
            tempGraphView.setLineChart(temp: WeatherViewModel.fiveDaysTemp[row ?? 0].temp, time: WeatherViewModel.fiveDaysTemp[row ?? 0].time)
        }
    }
    
    private func setForecast() {
        let forecast: String = "현재 기온은 21도이며 한때 흐린 상태입니다. 오후 12시~오후 1시에 맑은 상태가, 오후 2시에 대체로 흐린상태가 예상됩니다. 오늘 기온은 17도에서 25도사이입니다."
        
        tempGraphView.setForecast(forecast: forecast)
    }
}

extension WeatherViewController: WeatherTitleViewDelegate {
    func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
