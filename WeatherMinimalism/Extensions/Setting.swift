//
//  Setting.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 7/15/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

struct SettingSection {
    let sectionName: String
    var includedSettings: [Setting]
}

struct Setting {
    let name: String
    let toggable: Bool
}
