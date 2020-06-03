//
//  TodayDetailedOverviewView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/3/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class TodayDetailedOverviewView: UIView {
    
    let todayDetailedOverviewMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        self.addSubview(todayDetailedOverviewMainStackView)
        
        let contentConstraints = [
            todayDetailedOverviewMainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            todayDetailedOverviewMainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            todayDetailedOverviewMainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            todayDetailedOverviewMainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(contentConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
