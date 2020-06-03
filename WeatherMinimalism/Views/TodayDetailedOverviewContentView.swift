//
//  TodayDetailedOverviewContentView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/3/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class TodayDetailedOverviewContentView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 1
        return label
    }()
    
    let dataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        self.addSubview(titleLabel)
        self.addSubview(dataLabel)
        
        let contentConstraints = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            
            dataLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            dataLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            dataLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            dataLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ]
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        dataLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        dataLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate(contentConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
