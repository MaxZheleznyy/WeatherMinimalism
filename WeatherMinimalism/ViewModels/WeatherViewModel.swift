//
//  WeatherViewModel.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 4/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation
import CoreData

class WeatherViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    //MARK: - Contants
    private let apiKey = "ce8d992066007b3a50a1597aca48cf97"
    private var privateWeatherData: Forecast?
    private var fetchedCitiesController: NSFetchedResultsController<City>!
        
    var publicWeatherData: Forecast? {
        get {
            return privateWeatherData
        }
    }
    
    var currentCity: City? {
        get {
            checkFetchController()
            if let recentCity = fetchedCitiesController.fetchedObjects?.first {
                return recentCity
            } else {
                return nil
            }
        }
    }
    
    var publicSavedCities: [City] {
        get {
            checkFetchController()
            if let cities = fetchedCitiesController.fetchedObjects {
                return cities
            } else {
                return []
            }
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
    
    //MARK: - Network
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
    
    //MARK: - Local JSON
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
    
    //MARK: - Core Data
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
        if fetchedCitiesController == nil {
            let request = City.createFetchRequest()
            let sort = NSSortDescriptor(key: "addedDate", ascending: false)
            request.sortDescriptors = [sort]
            
            fetchedCitiesController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedCitiesController.delegate = self
        }

        do {
            try fetchedCitiesController.performFetch()
        } catch {
            print("Load cities failed: \(error)")
        }
    }
    
    func saveWeatherForCity(cityForWeather: Location, weatherFromServer: WeatherForTimeSlice) {
        DispatchQueue.main.async { [unowned self] in
            var cityToUpdate: City?
            
            let cityRequest = City.createFetchRequest()
            cityRequest.predicate = NSPredicate(format: "id == %d", cityForWeather.id)
            
            if let cities = try? self.persistentContainer.viewContext.fetch(cityRequest) {
                if cities.count > 0 {
                    // DB has the city already
                    cityToUpdate = cities[0]
                }
            }
            
            if cityToUpdate == nil {
                // We need to create a new city in DB
                let city = City(context: self.persistentContainer.viewContext)
                city.id = cityForWeather.id
                city.name = cityForWeather.name
                city.state = cityForWeather.state
                city.country = cityForWeather.country
                city.latitude = cityForWeather.lat
                city.longitude = cityForWeather.long
                city.addedDate = Date()
                
                cityToUpdate = city
            }
            
            guard let nonEmptyCityToUpdate = cityToUpdate else { return }
            let weather = CurrentWeather(context: self.persistentContainer.viewContext)
            weather.city = nonEmptyCityToUpdate
            weather.id = nonEmptyCityToUpdate.id
            weather.temperature = weatherFromServer.temperature ?? 0
            weather.timestamp = weatherFromServer.weatherTimestamp ?? 0
            
            nonEmptyCityToUpdate.currentWeather = weather
            
            self.saveContext()
            self.loadCitiesFromDB()
        }
    }
    
    private func checkFetchController() {
        if fetchedCitiesController == nil || fetchedCitiesController.fetchedObjects == nil || fetchedCitiesController.fetchedObjects?.count ?? 0 <= 0 {
            loadCitiesFromDB()
        }
    }
    
    private func saveContext () {
        do {
            try persistentContainer.viewContext.saveIfHasChanges()
        } catch {
            print("Save context failed: \(error)")
        }
    }
}
