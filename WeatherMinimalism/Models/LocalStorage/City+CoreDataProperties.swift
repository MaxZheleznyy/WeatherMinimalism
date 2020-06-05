//
//  City+CoreDataProperties.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/4/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var id: Int
    @NSManaged public var addedDate: Date
    @NSManaged public var name: String
    @NSManaged public var state: String
    @NSManaged public var country: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var currentWeather: CurrentWeather?

}
