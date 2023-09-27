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
        
        backgroundColor = .blue.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
