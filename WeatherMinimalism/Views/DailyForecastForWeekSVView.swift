//
//  DailyForecastForWeekSVView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/3/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class DailyForecastForWeekSVView: UIView {
    
    let dailyForecastForWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let bottomDividerView = self.addBottomDividerView()
        self.addSubview(dailyForecastForWeekStackView)
        
        let dailyForecastForWeekConstraints = [
            dailyForecastForWeekStackView.topAnchor.constraint(equalTo: self.topAnchor),
            dailyForecastForWeekStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dailyForecastForWeekStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dailyForecastForWeekStackView.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(dailyForecastForWeekConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
