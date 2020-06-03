//
//  TodayDetailedOverviewHorizontalSVView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/3/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class TodayDetailedOverviewHorizontalSVView: UIView {
    
    let todayDetailedOverviewHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        self.addSubview(todayDetailedOverviewHorizontalStackView)
        
        let contentConstraints = [
            todayDetailedOverviewHorizontalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            todayDetailedOverviewHorizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            todayDetailedOverviewHorizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            todayDetailedOverviewHorizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(contentConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
