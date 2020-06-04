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
    private var cities = [City]()
    
    var publicWeatherData: Forecast? {
        get {
            return privateWeatherData
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherMinimalism")
        
        container.loadPersistentStores { storeDescription, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Can't loadPersistentStores: \(error)")
            }
        }
        
        return container
    }()
    
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
                print("Fetch weather with lat and long failed: \(error)")
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
                print("Can't decode city.list.json file data: \(error)")
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
                print("Can't decode city.list.json file data: \(error)")
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
        
        saveCityToDB(location: location)
    }
    
    func saveCityToDB(location: Location) {
        DispatchQueue.main.async { [unowned self] in
            let city = City(context: self.persistentContainer.viewContext)
            city.id = location.id
            city.name = location.name
            city.state = location.state
            city.country = location.country
            city.latitude = location.lat
            city.longitude = location.long
            city.addedDate = Date()
            
            self.saveContext()
            self.loadCitiesFromDB()
        }
    }
    
    func loadCitiesFromDB() {
        let request = City.createFetchRequest()
        let sort = NSSortDescriptor(key: "addedDate", ascending: false)
        request.sortDescriptors = [sort]

        do {
            cities = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Load cities failed: \(error)")
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
    
    func saveContext () {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("Save context failed: \(error)")
            }
        }
    }
}
