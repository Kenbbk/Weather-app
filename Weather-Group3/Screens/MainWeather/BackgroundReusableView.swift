//
//  BackgroundReusableView.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 2023/09/27.
//

import UIKit

class BackgroundReusableView: UICollectionReusableView {
    
    static let identifier = "BackgroundReusableView"
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        backgroundColor = .gray.withAlphaComponent(0.1)
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapped() {
        print("tapped")
    }
    
    private func addGesture() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
}
