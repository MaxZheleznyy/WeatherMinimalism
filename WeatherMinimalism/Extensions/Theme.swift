//
//  Theme.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 7/15/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

enum Theme: Int {
    case deviceDefault
    case light
    case dark
}

extension Theme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .deviceDefault:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
