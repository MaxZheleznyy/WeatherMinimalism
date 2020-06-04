//
//  WeatherViewModel.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 4/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation
import CoreData

class WeatherViewModel {
    private let apiKey = "ce8d992066007b3a50a1597aca48cf97"
    
    private var privateWeatherData: Forecast?
    private let defaults = UserDefaults.standard
    private let storedLocationKey = "StoredLocation"
    
    var publicWeatherData: Forecast? {
        get {
            return privateWeatherData
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherMinimalism")
        
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchWeatherUsing(lat: Double, lon: Double, completion: @escaping (Forecast) -> ()) {
        let apiURL = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&units=metric&appid=\(apiKey)"

        guard let url = URL(string: apiURL) else { fatalError() }

        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let data = data else { return }
            do {
                let currentWeather = try JSONDecoder().decode(Forecast.self, from: data)
                self?.privateWeatherData = currentWeather
                completion(currentWeather)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func returnLocationFromJSONFile(cityName: String) -> Location? {
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let availableLocationsArray = try JSONDecoder().decode([Location].self, from: data)
                if let possibleCity = availableLocationsArray.first(where: { $0.name.contains(cityName.capitalized) }) {
                    return possibleCity
                }
            } catch {
                print("Can't decode city.list.json file data")
                return nil
            }
        }
        return nil
    }
    
    func returnLocationFromJSONFile(lat: Double, long: Double) -> Location? {
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let availableLocationsArray = try JSONDecoder().decode([Location].self, from: data)
                
                let possibleCitiesArray = availableLocationsArray.filter({ ($0.lat.returnAsOneDigitPrecision == lat.returnAsOneDigitPrecision) && ($0.long.returnAsOneDigitPrecision == long.returnAsOneDigitPrecision) })
                if let firstCity = possibleCitiesArray.first {
                    return firstCity
                }
            } catch {
                print("Can't decode city.list.json file data")
                return nil
            }
        }
        return nil
    }
    
    func saveNewCityToUserDefaults(location: Location) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(location) {
            defaults.set(encoded, forKey: storedLocationKey)
        }
    }
    
    func getCityFromUserDefauts() -> Location? {
        if let savedLocation = defaults.object(forKey: storedLocationKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedLocation = try? decoder.decode(Location.self, from: savedLocation) {
                return loadedLocation
            }
        }
        
        return nil
    }
}
