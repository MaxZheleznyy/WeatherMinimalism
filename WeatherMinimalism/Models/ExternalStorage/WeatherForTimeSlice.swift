//
//  WeatherTimeSlice.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 5/11/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

struct WeatherForTimeSlice: Decodable {
    let weatherTimestamp: Double?
    let temperature: Double?
    let feelsLike: Double?
    let sunriseTimestamp: Double?
    let sunsetTimestamp: Double?
    let humidity: Double?
    let visibility: Double?
    let uvIndex: Double?
    let weatherDetails: [WeatherDetails]?
    let dailyTemperature: DailyTemperature?
    
    enum CodingKeys: String, CodingKey {
        case humidity, visibility
        case weatherTimestamp = "dt"
        case temperature = "temp"
        case feelsLike = "feels_like"
        case sunriseTimestamp = "sunrise"
        case sunsetTimestamp = "sunset"
        case uvIndex = "uvi"
        case weatherDetails = "weather"
        case dailyTemperature = "daily"
    }
}
