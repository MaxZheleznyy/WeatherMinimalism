//
//  SelectCityCellView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/12/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class SelectCityCellView: UIView {
    
    let currentCityTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    let currentCityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    let currentCityTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    //TODO add image ("location.fill" SF symbol) whenever city is based on location
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(currentCityTimeLabel)
        self.addSubview(currentCityNameLabel)
        self.addSubview(currentCityTemperatureLabel)
        
        let contentConstraints = [
            currentCityTimeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            currentCityTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            currentCityNameLabel.topAnchor.constraint(equalTo: currentCityTimeLabel.bottomAnchor, constant: 8),
            currentCityNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            currentCityNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            
            currentCityTemperatureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            currentCityTemperatureLabel.leadingAnchor.constraint(equalTo: currentCityNameLabel.trailingAnchor, constant: 15),
            currentCityTemperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            currentCityTemperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
        ]
        
        currentCityTimeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        currentCityTimeLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        currentCityNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        currentCityNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        currentCityTemperatureLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        currentCityTemperatureLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate(contentConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

