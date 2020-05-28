//
//  TodayHourlyWeatherCVCell.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 5/8/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class TodayHourlyWeatherCVCell: UICollectionViewCell {

    static var identifier = "FutureWeatherCVCell"
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(temperatureLabel)
        
        let contentConstraints = [
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            weatherIcon.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            weatherIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            weatherIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            weatherIcon.heightAnchor.constraint(equalToConstant: 38),
            
            temperatureLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 4),
            temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ]
        
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        weatherIcon.setContentHuggingPriority(.defaultHigh, for: .vertical)
        weatherIcon.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        temperatureLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        temperatureLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate(contentConstraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        //TODO add reuse elements
    }
}
