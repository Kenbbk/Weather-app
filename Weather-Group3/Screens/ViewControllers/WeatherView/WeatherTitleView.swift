//
//  WeatherTitleView.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation
import UIKit

protocol WeatherTitleViewDelegate: AnyObject {
    func closeButtonTapped()
}

class WeatherTitleView: UIView {
    
    var labelSize: CGFloat = 20
    var imageSize: CGFloat = 20
    
    // MARK: - Properties
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        
        // 이미지를 포함한 NSAttributedString을 생성합니다.
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "thermometer.low") // 이미지 이름을 넣어주세요

        let attributedString = NSMutableAttributedString(attachment: imageAttachment)
        attributedString.append(NSAttributedString(string: " 기온"))
        
        label.attributedText = attributedString
        label.font = UIFont.boldSystemFont(ofSize: labelSize)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var delegate: WeatherTitleViewDelegate?
    lazy var closeButton: UIButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: imageSize, weight: .light)
        let image = UIImage(systemName: "x.circle", withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        addSubview(userNameLabel)
        addSubview(closeButton)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    // MARK: Action
    @objc func closeButtonTapped() {
        delegate?.closeButtonTapped()
    }
}
