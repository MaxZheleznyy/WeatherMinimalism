//
//  WeatherViewModel.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 4/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

class WeatherViewModel {
    private let apiKey = "ce8d992066007b3a50a1597aca48cf97"
    
    private var privateWeatherData: Forecast?
    
    var publicWeatherData: Forecast? {
        get {
            return privateWeatherData
        }
    }
    
    func fetchWeatherUsing(lat: String, lon: String, completion: @escaping (Forecast) -> ()) {
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
                if let possibleCity = availableLocationsArray.first(where: { $0.name?.contains(cityName) ?? false }) {
                    return possibleCity
                }
            } catch {
                print("Can't decode city.list.json file data")
                return nil
            }
        }
        return nil
    }
}
