//
//  DateExtension.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 5/8/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

extension Date {
    func dayOfWeekByString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
