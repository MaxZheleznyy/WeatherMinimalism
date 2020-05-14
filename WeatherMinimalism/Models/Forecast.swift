//
//  Forecast.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 4/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

struct Forecast: Decodable {
    let timezone: String?
    let lat: Double?
    let long: Double?
    let currentWeather: WeatherForTimeSlice?
    let hourlyWeather: [WeatherForTimeSlice]?
    
    enum CodingKeys: String, CodingKey {
        case lat, long
        case timezone = "timezone"
        case currentWeather = "current"
        case hourlyWeather = "hourly"
    }
}
