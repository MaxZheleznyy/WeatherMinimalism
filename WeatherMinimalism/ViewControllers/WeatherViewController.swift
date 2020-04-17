//
//  WeatherViewController.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 4/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let viewModel = WeatherViewModel()
    
    let selectedLocation: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "...Location"
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
        return label
    }()
    
    let currentTime: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "28 March 2020"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 10, weight: .heavy)
        return label
    }()
    
    let tempLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°C"
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
        return label
    }()
    
    let tempDescription: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    let tempIcon: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(systemName: "cloud.fill")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .gray
        return img
    }()
    
    let minTemp: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let maxTemp: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  °C"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavigationBar()
        setupViews()
        loadDataUsing(city: getCityFromUserDefaults())
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(
        title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton)),
            UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))
        ]
    }
    
    func setupViews() {
        view.addSubview(selectedLocation)
        view.addSubview(tempLabel)
        view.addSubview(tempIcon)
        view.addSubview(tempDescription)
        view.addSubview(currentTime)
        view.addSubview(minTemp)
        view.addSubview(maxTemp)
        
        selectedLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        selectedLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        selectedLocation.heightAnchor.constraint(equalToConstant: 70).isActive = true
        selectedLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
        currentTime.topAnchor.constraint(equalTo: selectedLocation.bottomAnchor, constant: 4).isActive = true
        currentTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        currentTime.heightAnchor.constraint(equalToConstant: 10).isActive = true
        currentTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
        tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        tempLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        tempLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        tempIcon.topAnchor.constraint(equalTo: tempLabel.bottomAnchor).isActive = true
        tempIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        tempIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tempIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        tempDescription.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 12.5).isActive = true
        tempDescription.leadingAnchor.constraint(equalTo: tempIcon.trailingAnchor, constant: 8).isActive = true
        tempDescription.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tempDescription.widthAnchor.constraint(equalToConstant: 250).isActive = true

        minTemp.topAnchor.constraint(equalTo: tempIcon.bottomAnchor, constant: 80).isActive = true
        minTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        minTemp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        minTemp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        maxTemp.topAnchor.constraint(equalTo: minTemp.bottomAnchor).isActive = true
        maxTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        maxTemp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        maxTemp.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func getCityFromUserDefaults() -> String {
        if let city = UserDefaults.standard.string(forKey: "SelectedLocation") {
            return city
        } else {
            return "New York"
        }
    }
    
    func loadDataUsing(city: String) {
        viewModel.fetchCurrentSpecificCityWeather(city: city) { weather in
             let formatter = DateFormatter()
             formatter.dateFormat = "dd MMM yyyy"
             let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
             
             DispatchQueue.main.async {
                 self.tempLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°C")
                 self.selectedLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                 self.tempDescription.text = weather.weather[0].description
                 self.currentTime.text = stringDate
                 self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C" )
                 self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
                 self.tempIcon.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                
                 UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedLocation")
             }
         }
    }
    
    @objc func handleAddPlaceButton() {
        let alertController = UIAlertController(title: "Change City", message: "", preferredStyle: .alert)
         alertController.addTextField { (textField : UITextField!) -> Void in
             textField.placeholder = "City Name"
         }
         let saveAction = UIAlertAction(title: "Change", style: .default, handler: { alert -> Void in
             let firstTextField = alertController.textFields![0] as UITextField
            guard let cityname = firstTextField.text else { return }
            self.loadDataUsing(city: cityname)
         })
        
         let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            print("Cancel")
         })
      

         alertController.addAction(saveAction)
         alertController.addAction(cancelAction)

         self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleRefresh() {
        loadDataUsing(city: getCityFromUserDefaults())
    }
}

