//
//  SelectCityTableViewCell.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/12/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class SelectCityTableViewCell: UITableViewCell {
    
    static let selectedCityCVIdentifier = "SelectCityTableViewCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("Unexpected call to coder-based init")
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //TODO add image ("location.fill" SF symbol) whenever city is based on location
    private func configureUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
            
        self.contentView.addSubview(currentCityNameLabel)
        self.contentView.addSubview(currentCityTemperatureLabel)
        
        let contentConstraints = [
            
            currentCityNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            currentCityNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            currentCityNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            
            currentCityTemperatureLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            currentCityTemperatureLabel.leadingAnchor.constraint(equalTo: currentCityNameLabel.trailingAnchor, constant: 15),
            currentCityTemperatureLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            currentCityTemperatureLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
        ]
        
        currentCityNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        currentCityNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        currentCityTemperatureLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        currentCityTemperatureLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate(contentConstraints)
    }
}

