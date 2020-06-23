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
    
    private let dailyWeather: [WeatherForDaily]?
    private let hourlyWeather: [WeatherForTimeSlice]?
    
    var publicDailyWeather: [WeatherForDaily]? {
        get {
            //return weather for next 9 days
            if let modifiedDailyWeather = dailyWeather?.prefix(11) {
                return Array(modifiedDailyWeather)
            } else {
                return []
            }
        }
    }
    
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
