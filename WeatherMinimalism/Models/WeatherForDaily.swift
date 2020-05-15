//
//  WeatherForDaily.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 5/15/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

struct WeatherForDaily: Decodable {
    let weatherTimestamp: Double?
    let weatherDetails: [WeatherDetails]?
    let dailyTemperature: DailyTemperature?
    
    enum CodingKeys: String, CodingKey {
        case weatherTimestamp = "dt"
        case weatherDetails = "weather"
        case dailyTemperature = "temp"
    }
}
