//
//  SettingsViewController.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/27/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var settings: [SettingSection] = []
    private let userDefaults = UserDefaults.standard
    
    private var theme: Theme {
        get {
            return userDefaults.selectedTheme
        } set {
            userDefaults.selectedTheme = newValue
            configureAppTheme(with: newValue)
        }
    }
    
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
        let useSystemDefaultSetting = Setting(name: "Use System Light/Dark Mode", toggable: true)
        let systemDefaultSettingSection = SettingSection(sectionName: "Automatic", includedSettings: [useSystemDefaultSetting])
        
        let useLightSetting = Setting(name: "Light", toggable: false)
        let useDarkSetting = Setting(name: "Dark", toggable: false)
        let customThemeSelectionSection = SettingSection(sectionName: "Manual", includedSettings: [useLightSetting, useDarkSetting])
        
        settings = [systemDefaultSettingSection, customThemeSelectionSection]
    }
    
    private func configureAppTheme(with: Theme) {
        view.window?.overrideUserInterfaceStyle = theme.userInterfaceStyle
    }
}

//MARK: - UITableView
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return theme == .deviceDefault ? 1 : settings.count
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
            
            cell.delegate = self
            cell.settingLabel.text = setting.name
            cell.isToggable = setting.toggable
            
            if setting.toggable {
                cell.selectionStyle = .none
                cell.isEnabled = theme == .deviceDefault
            } else if indexPath.section == 1 && indexPath.row == 0 { //light theme
                cell.isEnabled = theme == .light
            } else if indexPath.section == 1 && indexPath.row == 1 { //dark theme
                cell.isEnabled = theme == .dark
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        } else if indexPath.section == 1 && indexPath.row == 0 { //light theme
            theme = .light
            tableView.reloadData()
        } else if indexPath.section == 1 && indexPath.row == 1 { //dark theme
            theme = .dark
            tableView.reloadData()
        }
    }
}

extension SettingsViewController: SettingsTableViewCellDelegate {
    func settingSwitchToggled(isToggled: Bool) {
        if isToggled {
            theme = .deviceDefault
        } else {
            theme = traitCollection.userInterfaceStyle == .dark ? .dark : .light
        }
        
        tableView.reloadData()
    }
}
