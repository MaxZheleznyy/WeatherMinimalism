//
//  SettingsViewController.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/27/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

struct SettingSection {
    let sectionName: String
    var includedSettings: [Setting]
}

struct Setting {
    let name: String
    let toggable: Bool
    var enabled: Bool?
}

class SettingsViewController: UIViewController {
    
    var settings: [SettingSection] = []
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 44
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillUpData()
        tableView.delegate = self
        tableView.dataSource = self
        addTableView()
    }
    
    func addTableView() {
        view.addSubview(tableView)
        
        let mainConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(mainConstraints)
    }
    
    func fillUpData() {
        let useSystemDefaultSetting = Setting(name: "Use System Light/Dark Mode", toggable: true, enabled: true)
        let systemDefaultSettingSection = SettingSection(sectionName: "Automatic", includedSettings: [useSystemDefaultSetting])
        
        let useLightSetting = Setting(name: "Light", toggable: false, enabled: true)
        let useDarkSetting = Setting(name: "Dark", toggable: false, enabled: false)
        let customThemeSelectionSection = SettingSection(sectionName: "Manual", includedSettings: [useLightSetting, useDarkSetting])
        
        settings = [systemDefaultSettingSection, customThemeSelectionSection]
    }
}

//MARK: - UITableView
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let includedSettingsCount = settings[safe: section]?.includedSettings.count {
            return includedSettingsCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let settingHeader = settings[safe: section]?.sectionName {
            return settingHeader
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let setting = settings[safe: indexPath.section]?.includedSettings[indexPath.row] {
            let settingLabel = UILabel()
            settingLabel.translatesAutoresizingMaskIntoConstraints = false
            settingLabel.textAlignment = .left
            
            settingLabel.text = setting.name
            
            cell.contentView.addSubview(settingLabel)
            
            var constraints = [
                settingLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                settingLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8),
                settingLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                settingLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ]
            
            settingLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
            settingLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            settingLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            settingLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            if setting.toggable {
                let settingSwitch = UISwitch()
                settingSwitch.isOn = setting.enabled ?? false
                settingSwitch.setOn(setting.enabled ?? false, animated: true)
                settingSwitch.translatesAutoresizingMaskIntoConstraints = false
                cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
                
                cell.contentView.addSubview(settingSwitch)
                
                let additionalConstraints = [
                    settingSwitch.leadingAnchor.constraint(equalTo: settingLabel.trailingAnchor, constant: 8),
                    settingSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                    settingSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8)
                ]
                
                constraints.append(contentsOf: additionalConstraints)
                
                settingSwitch.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                settingSwitch.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            } else {
                if let enabled = setting.enabled, enabled == true {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            
            NSLayoutConstraint.activate(constraints)
        }
        
        return cell
    }
}
