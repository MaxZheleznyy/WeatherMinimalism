//
//  UserDefaultsExtension.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/30/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

extension UserDefaults {
    var preferManualTheme: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var preferDarkTheme: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}
