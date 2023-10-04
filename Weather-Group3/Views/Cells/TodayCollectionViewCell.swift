//
//  TodayCollectionViewCell.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation
import UIKit

class TodayCollectionViewCell: UICollectionViewCell {
    static let identifier = "todayCollectionViewCell"
    
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
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: labelSize)
        
        return label
    }()
    
    lazy var weatherStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempLabel])
        stackView.spacing = stackViewSpacing
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        
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
    
    func configure(with time: String, iconCode: String, temp: Double) {
        timeLabel.text = time
        
        // 날씨 정보에서 icon 코드 추출
        let code = iconCode
        displayWeatherIcon(iconCode: code)
        
        let formattedTemp = String(format: "%.1f", temp)
        tempLabel.text = String(formattedTemp)
    }
    
    // 아이콘 이미지를 다운로드하고 표시하는 함수
    func displayWeatherIcon(iconCode: String) {
        // 아이콘 이미지 URL 생성
        let iconURLString = "https://openweathermap.org/img/wn/\(iconCode).png"
        guard let iconURL = URL(string: iconURLString) else {
            return
        }
        
        // URLSession을 사용하여 이미지 다운로드
        let task = URLSession.shared.dataTask(with: iconURL) { (data, _, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                // 다운로드한 이미지를 메인 스레드에서 표시
                DispatchQueue.main.async {
                    self.iconImageView.image = image // image 표시!
                }
            }
        }
        
        task.resume()
    }
}
