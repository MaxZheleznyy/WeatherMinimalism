//
//  DoubleExtension.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 5/15/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

extension Double {
    var returnAsOneDigitPrecision: Double {
        let formatedString = String(format: "%.1f", self)
        return Double(formatedString)!
    }
}
