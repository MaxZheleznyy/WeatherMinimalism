//
//  UserDefaultsExtension.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/30/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

extension UserDefaults {
    var selectedTheme: Theme {
        get {
            register(defaults: [#function: Theme.deviceDefault.rawValue])
            return Theme(rawValue: integer(forKey: #function)) ?? .deviceDefault
        }
        set {
            set(newValue.rawValue, forKey: #function)
        }
    }
}
