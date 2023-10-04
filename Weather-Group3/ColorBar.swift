//
//  ColorBar.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 2023/09/29.
//

import UIKit


class ColorBar: UIView {
    
    let leftView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 2.5
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    let rightView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 2.5
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
   var colors = [CGColor]()
    
    var firstDouble: Double = 0
    
    var secondDouble: Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 2.5
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = bounds
        print(colors.count, "@@@@")
        gradientLayer.colors = colors
        layer.addSublayer(gradientLayer)
        configureLeftView()
        configureRightView()
        
    }
    
   
    
    private func configureLeftView() {
        addSubview(leftView)
        
        leftView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftView.topAnchor.constraint(equalTo: topAnchor),
            leftView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: firstDouble),
            leftView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    private func configureRightView() {
        addSubview(rightView)
        
        rightView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightView.topAnchor.constraint(equalTo: topAnchor),
            rightView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: secondDouble),
            rightView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraint(constraint: (Double, Double)) {
        
        firstDouble = constraint.0
        secondDouble = constraint.1

    }
    
}



