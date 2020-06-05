//
//  Location.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 5/15/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

struct Location: Codable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let lat: Double
    let long: Double
    
    enum CodingKeys: String, CodingKey {
        case id, name, state, country, lat, coord
        case long = "lon"
    }
}

// MARK: - Decodable
extension Location {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        
        let coord = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .coord)
        lat = try coord.decode(Double.self, forKey: .lat)
        long = try coord.decode(Double.self, forKey: .long)
    }
}
// MARK: - Encodable
extension Location {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(state, forKey: .state)
        try container.encode(country, forKey: .country)
        
        var coord = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .coord)
        try coord.encode(lat, forKey: .lat)
        try coord.encode(long, forKey: .long)
    }
}
