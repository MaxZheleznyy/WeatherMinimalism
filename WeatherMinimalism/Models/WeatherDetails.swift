//
//  WeatherDetails.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 5/11/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

struct WeatherDetails: Decodable {
    let id: Int?
    let description: String?
    let detailedDescription: String?
    let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id, icon
        case description = "main"
        case detailedDescription = "description"
    }
}
