//
//  FourthCell.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 10/5/23.
//

import UIKit

class FourthCell: UICollectionViewCell {
    
    static let identifier = "FourthCell"
    
    let leftPadding: CGFloat = 5
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "house")
        return iv
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "FEELS LIKE"
        label.textColor = .white
        return label
    }()
    
    let tempLabel: UILabel = {
       let label = UILabel()
        label.text = "31"
        label.textColor = .white
        return label
    }()
    
    let descriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.text = "Humidy is making it feel warmer"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubViews()
        configureImageView()
        configureTempLabel()
        configureTempLabel()
        configureDescriptionLabel()
    }
    
    private func addSubViews() {
        [imageView, titleLabel, tempLabel, descriptionLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
    }
    
    private func configureImageView() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            imageView.widthAnchor.constraint(equalToConstant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private func configureTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 3),
            
        ])
    }
    
    private func configureTempLabel() {
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            tempLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -leftPadding),
            
        ])
    }
    
   
    
}
