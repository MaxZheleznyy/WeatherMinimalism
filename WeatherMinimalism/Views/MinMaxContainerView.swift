//
//  MinMaxContainerView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/2/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class MinMaxContainerView: UIView {
    
    let dayOfTheWeekLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let todayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TODAY"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let maxTemp: UILabel = {
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
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let bottomDividerView = self.addBottomDividerView()
        
        self.addSubview(dayOfTheWeekLabel)
        self.addSubview(todayLabel)
        self.addSubview(maxTemp)
        self.addSubview(minTemp)
        
        let minMaxViewConstrainsts = [
            dayOfTheWeekLabel.topAnchor.constraint(equalTo: self.topAnchor),
            dayOfTheWeekLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            dayOfTheWeekLabel.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -8),
            
            todayLabel.topAnchor.constraint(equalTo: self.topAnchor),
            todayLabel.leadingAnchor.constraint(equalTo: dayOfTheWeekLabel.trailingAnchor, constant: 8),
            todayLabel.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -8),
            
            maxTemp.topAnchor.constraint(equalTo: self.topAnchor),
            maxTemp.leadingAnchor.constraint(equalTo: todayLabel.trailingAnchor, constant: 20),
            maxTemp.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -8),
            
            minTemp.topAnchor.constraint(equalTo: self.topAnchor),
            minTemp.leadingAnchor.constraint(equalTo: maxTemp.trailingAnchor, constant: 8),
            minTemp.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            minTemp.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -8)
        ]
        
        dayOfTheWeekLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        todayLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        maxTemp.setContentHuggingPriority(.defaultLow, for: .horizontal)
        minTemp.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate(minMaxViewConstrainsts)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
