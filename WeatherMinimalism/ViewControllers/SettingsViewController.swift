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
    var enabled: Bool
}

class SettingsViewController: UIViewController {
    
    var settings: [SettingSection] = []
    private let userDefaults = UserDefaults.standard
    
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
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.settingsTableViewCellIdentifier)
        
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
        
        switch traitCollection.userInterfaceStyle {
        case .dark:
            userDefaults.preferDarkTheme = true
        default:
            userDefaults.preferDarkTheme = false
        }
        
        let useSystemDefaultSetting = Setting(name: "Use System Light/Dark Mode", toggable: true, enabled: !userDefaults.preferManualTheme)
        let systemDefaultSettingSection = SettingSection(sectionName: "Automatic", includedSettings: [useSystemDefaultSetting])
        
        let useLightSetting = Setting(name: "Light", toggable: false, enabled: !userDefaults.preferDarkTheme)
        let useDarkSetting = Setting(name: "Dark", toggable: false, enabled: userDefaults.preferDarkTheme)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.settingsTableViewCellIdentifier, for: indexPath) as? SettingsTableViewCell, let setting = settings[safe: indexPath.section]?.includedSettings[indexPath.row] {
            
            cell.settingLabel.text = setting.name
            cell.isToggable = setting.toggable
            cell.isEnabled = setting.enabled
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let enabledState = settings[safe: indexPath.section]?.includedSettings[safe: indexPath.row]?.enabled {
            settings[indexPath.section].includedSettings[indexPath.row].enabled = !enabledState
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
