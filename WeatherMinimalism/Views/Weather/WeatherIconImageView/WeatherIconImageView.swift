//
//  WeatherIconImageView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/3/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class WeatherIconImageView: UIImageView {
    
    let activityIndicator: UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView(style: .medium)
        aI.translatesAutoresizingMaskIntoConstraints = false
        aI.hidesWhenStopped = true
        return aI
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(activityIndicator)
        
        let contentConstraints = [
            activityIndicator.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
            activityIndicator.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(contentConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
