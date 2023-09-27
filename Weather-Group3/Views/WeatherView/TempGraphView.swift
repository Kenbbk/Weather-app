//
//  TempGraphView.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation
import UIKit

class TempGraphView: UIView {
    
    var viewTitle: String = "View Title"
    var labelSize: CGFloat = 15
    // 표시되는 날짜
    var selectedDate: String = "2023년 9월 26일 화요일"
    // stackView의 spacing
    var stackViewHoirzontalSpacing: CGFloat = 2
    // leading, trailing constraint 값
    var leadingTrailingConstraint: CGFloat = 16
    
    // MARK: - Properties
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: labelSize)
        label.text = selectedDate
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
    
    lazy var forecastLabel: UILabel = {
        let label = UILabel()
        label.text = "일기예보"
        label.font = UIFont.boldSystemFont(ofSize: labelSize)
    
        return label
    }()
    
    lazy var forecastTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: labelSize)
    
        return textView
    }()
    
    lazy var forecastStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [forecastLabel, forecastTextView])
        stackView.spacing = stackViewHoirzontalSpacing
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
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
            
            forecastStackView.topAnchor.constraint(equalTo: tempStackView.bottomAnchor, constant: 10),
            forecastStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingConstraint),
            forecastStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingTrailingConstraint),
            forecastStackView.heightAnchor.constraint(equalToConstant: 200)
//            forecastStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setTemp(currentTemp: String, highTemp: String, lowTemp: String) {
        currentTempLabel.text = "\(currentTemp)\(WeatherViewModel().tempUnit)"
        highTempLabel.text = "최고:\(highTemp)\(WeatherViewModel().tempUnit) "
        lowTempLabel.text = "최저:\(lowTemp)\(WeatherViewModel().tempUnit)"
    }
    
    func setForecast(forecast: String) {
        forecastTextView.text = forecast
    }
}
