//
//  CustomCell.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 2023/09/28.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    static let identifier = "CustomCell"
    
    let innerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInnerView()
//        contentView.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func maskCell(fromTop margin: CGFloat) {
        layer.mask = visibilityMask(withLocation: margin / frame.size.height)
        layer.masksToBounds = true
    }

    private func visibilityMask(withLocation location: CGFloat) -> CAGradientLayer {
        let mask = CAGradientLayer()
        
        mask.frame = bounds
        print(bounds, "*******")
        mask.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        let num = location as NSNumber
        print(location, "@@@")
        mask.locations = [num, num]
        return mask
    }
    
    private func configureInnerView() {
        contentView.addSubview(innerView)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            innerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            innerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            innerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            innerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7)
        ])
    }
    
}
