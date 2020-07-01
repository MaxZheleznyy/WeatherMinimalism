//
//  SettingsTableViewCell.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/30/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let settingsTableViewCellIdentifier = "SettingsTableViewCell"
    
    var isToggable = false {
        didSet {
            setToggleVisibility()
        }
    }
    
    var isEnabled = false {
        didSet {
            updateEnableState()
        }
    }
    
    let settingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let settingSwitch: UISwitch = {
        let settingSwitch = UISwitch()
        settingSwitch.translatesAutoresizingMaskIntoConstraints = false
        return settingSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("Unexpected call to coder-based init")
        super.init(coder: aDecoder)
    }
    
    private func configureUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
            
        self.contentView.addSubview(settingLabel)
        self.contentView.addSubview(settingSwitch)
        
        let constraints = [
            settingLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            settingLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            settingLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            settingLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            settingSwitch.leadingAnchor.constraint(equalTo: settingLabel.trailingAnchor, constant: 8),
            settingSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            settingSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)
        ]
        
        settingLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        settingLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        settingLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        settingLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate(constraints)
        
        setToggleVisibility()
    }
    
    private func setToggleVisibility() {
        settingSwitch.isHidden = !isToggable
        settingSwitch.isEnabled = isToggable
    }
    
    private func updateEnableState() {
        if isToggable {
            self.settingSwitch.isOn = isEnabled
            self.settingSwitch.setOn(isEnabled, animated: true)
        } else {
            self.accessoryType = isEnabled ? .checkmark : .none
        }
    }
}
