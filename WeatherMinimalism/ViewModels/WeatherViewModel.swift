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
    
    private var currenLocation: Location?
    private var savedLocations: [Location] = []
        
    var publicWeatherData: Forecast? {
        get {
            return privateWeatherData
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        if let container = try? PersistentContainer.container() {
            return returnConfigredContainer(container: container)
        } else {
            let container = NSPersistentContainer(name: "WeatherMinimalism")
            return returnConfigredContainer(container: container)
        }
    }()
    
    //MARK: - Main
    func getCurrentLocation() -> Location? {
        if let location = currenLocation {
            return location
        } else {
            checkFetchController()
            if let recentCity = fetchedCitiesController.fetchedObjects?.first {
                let location = Location(id: recentCity.id, name: recentCity.name, state: recentCity.state, country: recentCity.country, lat: recentCity.latitude, long: recentCity.longitude)
                return location
            } else {
                return nil
            }
        }
    }
    
    func getSavedLocations() -> [Location] {
        if savedLocations.isEmpty == false {
            return savedLocations
        } else {
            checkFetchController()
            if let cities = fetchedCitiesController.fetchedObjects {
                savedLocations.removeAll()
                
                for city in cities {
                    let location = Location(id: city.id, name: city.name, state: city.state, country: city.country, lat: city.latitude, long: city.longitude)
                    savedLocations.append(location)
                }
                
                return savedLocations
            } else {
                return []
            }
        }
    }
    
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
    func returnFirstLocationFromJSONFile(cityName: String) -> Location? {
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
    
    func returnLocationsFromJSONFile(cityName: String) -> [Location] {
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let availableLocationsArray = try JSONDecoder().decode([Location].self, from: data)
                
                return availableLocationsArray.filter({ $0.name.contains(cityName.capitalized)})
            } catch {
                print("Can't decode city.list.json file data: \(error)")
                return []
            }
        }
        return []
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
    func saveCityToDB(locationToSave: Location?, cityToSave: City?) {
        guard locationToSave != nil || cityToSave != nil else { return }
        
        DispatchQueue.main.async { [unowned self] in
            if let nonEmptyLocation = locationToSave {
                _ = self.decodeLocationIntoCity(location: nonEmptyLocation)
            } else if let nonEmptyCity = cityToSave {
                let city = City(context: self.persistentContainer.viewContext)
                city.id = nonEmptyCity.id
                city.name = nonEmptyCity.name
                city.state = nonEmptyCity.state
                city.country = nonEmptyCity.country
                city.latitude = nonEmptyCity.latitude
                city.longitude = nonEmptyCity.longitude
                city.addedDate = Date()
            }
            
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
    
    func saveWeatherForCity(location: Location, weatherFromServer: WeatherForTimeSlice) {
        DispatchQueue.main.async { [unowned self] in
            var cityToUpdate: City?
            
            let cityRequest = City.createFetchRequest()
            cityRequest.predicate = NSPredicate(format: "id == %d", location.id)
            
            if let cities = try? self.persistentContainer.viewContext.fetch(cityRequest) {
                if cities.count > 0 {
                    // DB has the city already
                    cityToUpdate = cities[0]
                }
            }
            
            if cityToUpdate == nil {
                // We need to create a new city in DB
                cityToUpdate = self.decodeLocationIntoCity(location: location)
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
    
    func removeCityFromDB(cityAt: IndexPath) {
        let cityToDelete = fetchedCitiesController.object(at: cityAt)
        persistentContainer.viewContext.delete(cityToDelete)
        
        saveContext()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .delete {
            guard let nonEmptyIndexPath = indexPath else { return }
            let data = [0: nonEmptyIndexPath]

            NotificationCenter.default.post(name: .readyToDeleteCityRow, object: self, userInfo: data)
        }
    }
    
    private func checkFetchController() {
        if fetchedCitiesController == nil || fetchedCitiesController.fetchedObjects == nil {
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
    
    // MARK: - Support
    private func returnConfigredContainer(container: NSPersistentContainer) -> NSPersistentContainer {
        container.loadPersistentStores { storeDescription, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Can't loadPersistentStores: \(error)")
            }
        }
        
        return container
    }
    
    func decodeCityIntoLocation(city: City) -> Location {
        let location = Location(id: city.id, name: city.name, state: city.state, country: city.country, lat: city.latitude, long: city.longitude)
        return location
    }
    
    private func decodeLocationIntoCity(location: Location) -> City {
        let city = City(context: self.persistentContainer.viewContext)
        city.id = location.id
        city.name = location.name
        city.state = location.state
        city.country = location.country
        city.latitude = location.lat
        city.longitude = location.long
        city.addedDate = Date()
        
        self.saveContext()
        
        return city
    }
}
