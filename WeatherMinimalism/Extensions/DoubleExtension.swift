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
    
    var timestampAsStringedHourMinuteForCurrentTimeZone: String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
