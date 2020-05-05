//
//  WeatherViewController.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 4/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    //MARK: - Contants
    let viewModel = WeatherViewModel()
    
    var locationManager = CLLocationManager()
    
    let spinnerView = SpinnerViewController()
    
    let headerContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let selectedLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "...Location"
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°C"
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
        return label
    }()
    
    let tempDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
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

    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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
        view.addSubview(headerContainerView)
        headerContainerView.addSubview(selectedLocation)
        headerContainerView.addSubview(tempLabel)
        headerContainerView.addSubview(tempDescription)
        view.addSubview(minTemp)
        view.addSubview(maxTemp)
        
        let constraints = [
            headerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            selectedLocation.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 20),
            selectedLocation.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 18),
            selectedLocation.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -18),
            selectedLocation.heightAnchor.constraint(equalToConstant: 70),

            tempLabel.topAnchor.constraint(equalTo: selectedLocation.bottomAnchor, constant: 20),
            tempLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 18),
            tempLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -18),
            tempLabel.heightAnchor.constraint(equalToConstant: 70),

            tempDescription.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 12.5),
            tempDescription.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 18),
            tempDescription.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -18),
            tempDescription.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -8),
            tempDescription.heightAnchor.constraint(equalToConstant: 20),

            minTemp.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 80),
            minTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            minTemp.heightAnchor.constraint(equalToConstant: 20),
            minTemp.widthAnchor.constraint(equalToConstant: 100),
            
            maxTemp.topAnchor.constraint(equalTo: minTemp.bottomAnchor),
            maxTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            maxTemp.heightAnchor.constraint(equalToConstant: 20),
            maxTemp.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Actions
    func getCityFromUserDefaults() -> String {
        if let city = UserDefaults.standard.string(forKey: "SelectedLocation") {
            return city
        } else {
            return "New York"
        }
    }
    
    func loadDataUsing(city: String) {
        showSpinner()
        viewModel.fetchWeatherUsing(city: city) { [weak self] weather in
             self?.updateUIWith(weather: weather)
         }
    }
    
    func loadDataUsing(lat: String, lon: String) {
        showSpinner()
        viewModel.fetchWeatherUsing(lat: lat, lon: lon) { [weak self] weather in
            self?.updateUIWith(weather: weather)
        }
    }
    
    func updateUIWith(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°C")
            self.selectedLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
            self.tempDescription.text = weather.weather[0].description
            self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C" )
            self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
           
            self.dismissSpinner()
            UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedLocation")
        }
    }
    
    private func showSpinner() {
        addChild(spinnerView)
        spinnerView.view.frame = view.frame
        view.addSubview(spinnerView.view)
        spinnerView.didMove(toParent: self)
        
        self.navigationItem.toggleNavBarButtons(isEnabled: false)
    }
    
    private func dismissSpinner() {
        spinnerView.willMove(toParent: nil)
        spinnerView.view.removeFromSuperview()
        spinnerView.removeFromParent()
        
        self.navigationItem.toggleNavBarButtons(isEnabled: true)
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

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
        guard let location = locations[safe: 0]?.coordinate else { return }
        loadDataUsing(lat: location.latitude.description, lon: location.longitude.description)
    }
}
