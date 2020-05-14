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
    let weatherDetails: [WeatherDetails]?
    
    enum CodingKeys: String, CodingKey {
        case weatherTimestamp = "dt"
        case temperature = "temp"
        case weatherDetails = "weather"
    }
}
