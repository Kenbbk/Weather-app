//
//  MainHeaderView.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 2023/09/27.
//

import UIKit

class MainHeaderView: UIView {
    
    
    
    var topConstraint: NSLayoutConstraint!
   
    var topConstraintConstant: CGFloat = 30 {
        didSet {
            topConstraint.constant = topConstraintConstant
            
            if topConstraint.constant < 25 {
                maxMinLabel.alpha = slopeCalculatorService.calculateY(x: topConstraint.constant, point1: (25,1), point2: (18,0))!
                descriptionLabelLabel.alpha = slopeCalculatorService.calculateY(x: topConstraint.constant, point1: (18,1), point2: (10,0))!
                temperatureLabel.alpha = slopeCalculatorService.calculateY(x: topConstraint.constant, point1: (10,1), point2: (2,0))!
                hiddenTemperatureLabel.alpha = slopeCalculatorService.calculateY(x: topConstraint.constant, point1: (2,0), point2: (-2,1))!
            }
            
            if topConstraint.constant >= 32 {
                maxMinLabel.alpha = 1
            }
        }
    }
    
    let slopeCalculatorService = SlopeCalculatorService()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        return label
    }()
    
    let hiddenTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "24º | Mostly Cloudy"
        label.alpha = 0
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "24º "
        label.font = UIFont.systemFont(ofSize: 60)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabelLabel: UILabel = {
        let label = UILabel()
        label.text = "Mostly Cloudy"
        label.font = UIFont.systemFont(ofSize: 26)
        label.textAlignment = .center
        return label
    }()
    
    let maxMinLabel: UILabel = {
        let label = UILabel()
        label.text = "H:26º L:19º"
        label.font = UIFont.systemFont(ofSize: 26)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        clipsToBounds = true
        
        addSubViews()
        configureCityLabel()
        configureTemperatureLabel()
        configureHiddenTemperatrueLabel()
        configureDescroptionLabel()
        configureMaxMinLabel()
    }
    
    private func addSubViews() {
        [cityLabel, temperatureLabel, hiddenTemperatureLabel,descriptionLabelLabel, maxMinLabel].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureCityLabel() {
        topConstraint = cityLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        NSLayoutConstraint.activate([
            topConstraint,
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configureTemperatureLabel() {
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            //            temperatureLabel.widthAnchor.constraint(equalToConstant: 60),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureHiddenTemperatrueLabel() {
        NSLayoutConstraint.activate([
            hiddenTemperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor),
            hiddenTemperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            hiddenTemperatureLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func configureDescroptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabelLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            descriptionLabelLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabelLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func configureMaxMinLabel() {
        NSLayoutConstraint.activate([
            maxMinLabel.topAnchor.constraint(equalTo: descriptionLabelLabel.bottomAnchor),
            maxMinLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            maxMinLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
}

