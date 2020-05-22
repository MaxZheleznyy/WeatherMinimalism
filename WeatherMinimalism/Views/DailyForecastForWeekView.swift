//
//  DailyForecastForWeekView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 5/22/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class DailyForecastForWeekView: UIView {
    
    let dayOfTheWeekLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    let weatherForDayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let maxTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let minTemp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addSubview(dayOfTheWeekLabel)
        self.addSubview(weatherForDayImageView)
        self.addSubview(maxTempLabel)
        self.addSubview(minTemp)
        
        let contentConstraints = [
            dayOfTheWeekLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            dayOfTheWeekLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            weatherForDayImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            weatherForDayImageView.leadingAnchor.constraint(equalTo: dayOfTheWeekLabel.trailingAnchor, constant: 8),
            weatherForDayImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            weatherForDayImageView.heightAnchor.constraint(equalToConstant: 50),
            weatherForDayImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            maxTempLabel.leadingAnchor.constraint(equalTo: weatherForDayImageView.trailingAnchor, constant: 8),
            maxTempLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            minTemp.leadingAnchor.constraint(equalTo: maxTempLabel.trailingAnchor, constant: 16),
            minTemp.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            minTemp.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        dayOfTheWeekLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        weatherForDayImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        maxTempLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        minTemp.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate(contentConstraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
