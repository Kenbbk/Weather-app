//
//  WeatherTitleView.swift
//  Weather-Group3
//
//  Created by t2023-m0059 on 2023/09/27.
//

import Foundation
import UIKit

class WeatherTitleView: UIView {
    
    var viewTitle: String = "View Title"
    var labelSize: CGFloat = 20
    var imageSize: CGFloat = 20
    
    // MARK: - Properties
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = viewTitle
        label.font = UIFont.boldSystemFont(ofSize: labelSize)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: imageSize, weight: .light)
        let image = UIImage(systemName: "x.circle", withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        
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
}
