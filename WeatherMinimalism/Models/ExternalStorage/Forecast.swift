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
    let dailyWeather: [WeatherForDaily]?
    
    private let hourlyWeather: [WeatherForTimeSlice]?
    
    var publicHourlyWeather: [WeatherForTimeSlice] {
        get {
            //return weather for current hour + next 24
            if let modifiedHourlyWeather = hourlyWeather?.prefix(25) {
                return Array(modifiedHourlyWeather)
            } else {
                return []
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case lat, long
        case timezone = "timezone"
        case currentWeather = "current"
        case hourlyWeather = "hourly"
        case dailyWeather = "daily"
    }
}
