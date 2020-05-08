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
    
    private var privateWeatherData: WeatherModel?
    
    var publicWeatherData: WeatherModel? {
        get {
            return privateWeatherData
        }
    }
    
    func fetchWeatherUsing(city: String, completion: @escaping (WeatherModel) -> ()) {
        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        let apiURL = "http://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&appid=\(apiKey)"

        guard let url = URL(string: apiURL) else { fatalError() }
                     
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
        guard let data = data else { return }
            do {
                let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                self?.privateWeatherData = currentWeather
                completion(currentWeather)
            } catch {
                 print(error)
            }

        }.resume()
    }
    
    func fetchWeatherUsing(lat: String, lon: String, completion: @escaping (WeatherModel) -> ()) {
        let API_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        
        guard let url = URL(string: API_URL) else { fatalError() }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let data = data else { return }
            do {
                let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                self?.privateWeatherData = currentWeather
                completion(currentWeather)
            } catch {
                print(error)
            }
        }.resume()
    }
}
