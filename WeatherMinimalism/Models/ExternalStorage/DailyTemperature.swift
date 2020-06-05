//
//  DailyTemperature.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 5/14/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

struct DailyTemperature: Decodable {
    let day: Double?
    let min: Double?
    let max: Double?
}
