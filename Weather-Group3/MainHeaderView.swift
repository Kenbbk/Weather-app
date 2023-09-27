//
//  MainHeaderView.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 2023/09/27.
//

import UIKit

class MainHeaderView: UIView {
    
    var topConstraint: NSLayoutConstraint!
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
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
        backgroundColor = .systemGray5
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        clipsToBounds = true
        backgroundColor = .white
        addSubViews()
        configureCityLabel()
        configureTemperatureLabel()
        configureDescroptionLabel()
        configureMaxMinLabel()
    }
    
    private func addSubViews() {
        [cityLabel, temperatureLabel, descriptionLabelLabel, maxMinLabel].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureCityLabel() {
        topConstraint = cityLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30)
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

