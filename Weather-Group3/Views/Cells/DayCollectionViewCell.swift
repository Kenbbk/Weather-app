//
//  DayCollectionViewCell.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation
import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    static let identifier = "dayCollectionViewCell"

    var labelSize: CGFloat = 14
    var stackViewSpacing: CGFloat = 2
    
    // MARK: - Properties
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: labelSize)
        
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var lowTempLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: labelSize)
        
        return label
    }()
    
    lazy var highTempLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: labelSize)
        
        return label
    }()
    
    // progress bar가 들어가야할 부분
    
    lazy var weatherStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconImageView, lowTempLabel, highTempLabel])
        stackView.spacing = stackViewSpacing
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func setUI() {
        addSubview(weatherStackView)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            weatherStackView.topAnchor.constraint(equalTo: topAnchor),
            weatherStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            weatherStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configure(with time: String, iconCode: String, lowTemp: Double, highTemp: Double) {
        timeLabel.text = time
        
        let code = iconCode
        TodayCollectionViewCell().displayWeatherIcon(iconCode: code, imageView: self.iconImageView)
        
        let formattedLowTemp = String(format: "%.1f", lowTemp)
        lowTempLabel.text = formattedLowTemp
        let formattedHighTemp = String(format: "%.1f", highTemp)
        highTempLabel.text = formattedHighTemp
    }
}
