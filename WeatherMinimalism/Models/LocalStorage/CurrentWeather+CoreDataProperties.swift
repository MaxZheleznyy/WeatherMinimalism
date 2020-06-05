//
//  CurrentWeather+CoreDataProperties.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/4/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrentWeather {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CurrentWeather> {
        return NSFetchRequest<CurrentWeather>(entityName: "CurrentWeather")
    }

    @NSManaged public var id: Int
    @NSManaged public var temperature: Double
    @NSManaged public var timestamp: Double
    @NSManaged public var city: City?

}
