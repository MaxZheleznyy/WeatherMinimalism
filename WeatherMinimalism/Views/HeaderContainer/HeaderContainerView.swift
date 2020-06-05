//
//  HeaderContainerView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/2/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class HeaderContainerView: UIView {
    
    let selectedLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "...Location"
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
        return label
    }()
    
    let tempDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 80, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        self.addSubview(selectedLocation)
        self.addSubview(tempLabel)
        self.addSubview(tempDescription)
        
        let contentConstraints = [
            selectedLocation.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            selectedLocation.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            selectedLocation.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            tempDescription.topAnchor.constraint(equalTo: selectedLocation.bottomAnchor, constant: 0),
            tempDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            tempDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),

            tempLabel.topAnchor.constraint(lessThanOrEqualTo: tempDescription.bottomAnchor, constant: 0),
            tempLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            tempLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
            tempLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ]
        
        selectedLocation.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tempDescription.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tempLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate(contentConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
