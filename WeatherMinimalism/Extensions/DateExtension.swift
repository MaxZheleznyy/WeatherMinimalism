//
//  DateExtension.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 5/8/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

extension Date {
    func dayOfWeekByString(specificDate: Date? = nil) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        if let nonEmptySpecificDate = specificDate {
            return dateFormatter.string(from: nonEmptySpecificDate).capitalized
        } else {
            return dateFormatter.string(from: self).capitalized
        }
    }
    
    func daysOfWeekArray() -> [String?] {
        var arrayOfWeekdays: [String?] = []
        
        for number in 1...8 {
            let modifiedDate = Calendar.current.date(byAdding: .day, value: number, to: self)
            arrayOfWeekdays.append(dayOfWeekByString(specificDate: modifiedDate))
        }
        
        return arrayOfWeekdays
    }
}
