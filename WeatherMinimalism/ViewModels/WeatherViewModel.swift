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
    
    func fetchWeatherUsing(city: String, completion: @escaping (Forecast) -> ()) {
//        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        //TODO add dictionary of cities. Right now just using New York location
        let apiURL = "https://api.openweathermap.org/data/2.5/onecall?lat=48.1371&lon=11.5754&exclude=minutely&units=metric&appid=\(apiKey)"

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
}
