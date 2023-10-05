//
//  SecondCell.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 2023/09/29.
//

import UIKit

class SecondCell: UICollectionViewCell {
    
    static let identifier = "SecondCell"
    
    let padding: CGFloat = 10
    
    let liner: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.textColor = .white
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "house")
        iv.tintColor = .black
        return iv
    }()
    
    let lowLabel: UILabel = {
        let label = UILabel()
        label.text = "17"
        label.textColor = .systemGray6
        return label
    }()
    
    let highLabel: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.textColor = .white
        return label
    }()
    
    let colorBar = ColorBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func colorViews(min: Double, max: Double) {
        colorBar.setConstraint(constraint: (min, max))
    }
    
    func configure(model: OneDayWeather) {
        ImageLoader().loadImage(iconCode: model.icon) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let image):
                DispatchQueue.main.asyncAndWait {
                    self.imageView.image = image
                }
            }
        }
        
        dayLabel.text = model.day
        TodayCollectionViewCell().displayWeatherIcon(iconCode: model.icon, imageView: self.imageView)
//        imageView.image = UIImage(systemName: model.icon)
        lowLabel.text = "\(Int(model.lowTemp))"
        highLabel.text = "\(Int(model.highTemp))"
        
    }
    
    
    //MARK: - UI
    private func configureUI() {
        configureLiner()
        configureDayLabel()
        configureImageView()
        configureLowLabel()
        configureHighLabel()
        configureColorBar()
    }
    
    private func configureLiner() {
        contentView.addSubview(liner)
        liner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            liner.topAnchor.constraint(equalTo: contentView.topAnchor),
            liner.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            liner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            liner.heightAnchor.constraint(equalToConstant: 0.2)
        ])
    }
    
    private func configureDayLabel() {
        
        contentView.addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding)
        ])
    }
    
    private func configureImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureLowLabel() {
        contentView.addSubview(lowLabel)
        lowLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lowLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lowLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 30),
            
        ])
    }
    
    private func configureHighLabel() {
        contentView.addSubview(highLabel)
        highLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            highLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            highLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureColorBar() {
        contentView.addSubview(colorBar)
        colorBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorBar.leadingAnchor.constraint(equalTo: lowLabel.trailingAnchor, constant: 10),
            colorBar.trailingAnchor.constraint(equalTo: highLabel.leadingAnchor, constant: -10),
            colorBar.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
}
