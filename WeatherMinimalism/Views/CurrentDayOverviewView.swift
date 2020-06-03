//
//  CurrentDayOverviewView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/3/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class CurrentDayOverviewView: UIView {
    
    let currentDayOverviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        self.addSubview(currentDayOverviewLabel)
        let bottomDividerView = self.addBottomDividerView()
        
        
        
        let currentDayOverviewConstraints = [
            currentDayOverviewLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            currentDayOverviewLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            currentDayOverviewLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            currentDayOverviewLabel.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(currentDayOverviewConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
