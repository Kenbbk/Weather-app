//
//  TempGraphView.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation
import UIKit
import Charts

class TempGraphView: UIView {
    
    var viewTitle: String = "View Title"
    var labelSize: CGFloat = 15
    // stackView의 spacing
    var stackViewHoirzontalSpacing: CGFloat = 2
    // leading, trailing constraint 값
    var leadingTrailingConstraint: CGFloat = 16
    
    // MARK: - Properties
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: labelSize)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: labelSize)
        
        return label
    }()
    
    lazy var highTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: labelSize)
        
        return label
    }()
    
    lazy var lowTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: labelSize)
        
        return label
    }()
    
    lazy var lowHighStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [highTempLabel, lowTempLabel])
        stackView.spacing = stackViewHoirzontalSpacing
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        return stackView
    }()
    
    lazy var tempStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentTempLabel, lowHighStackView])
        stackView.spacing = stackViewHoirzontalSpacing
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var tempLineChartView: LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.isUserInteractionEnabled = false
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        return lineChartView
    }()
    
    lazy var forecastLabel: UILabel = {
        let label = UILabel()
        label.text = "일기예보"
        label.font = UIFont.boldSystemFont(ofSize: labelSize)
        
        return label
    }()
    
    lazy var forecastTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: labelSize)
        textView.isScrollEnabled = false // 스크롤 비활성화
        textView.textContainerInset = .zero // 텍스트 컨테이너 여백 제거
        textView.textContainer.lineFragmentPadding = 0 // 텍스트 줄 여백 제거
        
        return textView
    }()
    
    lazy var forecastStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [forecastLabel, forecastTextView])
        stackView.spacing = stackViewHoirzontalSpacing
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        setUI()
        setConstraint()
    }
    
    private func setUI() {
        addSubview(dateLabel)
        addSubview(lineView)
        addSubview(tempStackView)
        addSubview(tempLineChartView)
        addSubview(forecastStackView)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            lineView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            tempStackView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 10),
            tempStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingConstraint),
            //            tempStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: leadingTrailingConstraint),
            
            tempLineChartView.topAnchor.constraint(equalTo: tempStackView.bottomAnchor, constant: 10),
            tempLineChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingConstraint),
            tempLineChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingTrailingConstraint),
            tempLineChartView.bottomAnchor.constraint(equalTo: forecastStackView.topAnchor, constant: -10),
            
            forecastStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingConstraint),
            forecastStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingTrailingConstraint),
            forecastStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setDate(date: String) {
        dateLabel.text = date
    }
    
    func setTemp(currentTemp: String, highTemp: String, lowTemp: String) {
        currentTempLabel.text = "\(currentTemp)\(WeatherViewModel().tempUnit)"
        highTempLabel.text = "최고:\(highTemp)\(WeatherViewModel().tempUnit) "
        lowTempLabel.text = "최저:\(lowTemp)\(WeatherViewModel().tempUnit)"
    }
    
    func setLineChart(temp: [Double], time: [String]) {
        // 시간대별 기온 데이터 (예시)
        let temperatures: [Double] = temp
        
        // 시간대 데이터 (예시)
        let timeLabels: [String] = time
        
        // 차트 데이터 설정
        var entries: [ChartDataEntry] = []
        for i in 0..<temperatures.count {
            let entry = ChartDataEntry(x: Double(i), y: temperatures[i])
            entries.append(entry)
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "온도")
        dataSet.colors = [NSUIColor.black] // 그래프 색상 설정
        dataSet.circleColors = [NSUIColor.blue]
        
        let data = LineChartData(dataSet: dataSet)
        tempLineChartView.data = data
        
        // X축 설정
        tempLineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: timeLabels)
        tempLineChartView.xAxis.granularity = 1
    }
    
    func setForecast(forecast: String) {
        forecastTextView.text = forecast
    }
}
