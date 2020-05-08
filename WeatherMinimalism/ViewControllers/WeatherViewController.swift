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
    
    var headerContainerViewHeight: NSLayoutConstraint?
    var headerHeightToUse: CGFloat = 250 {
        didSet {
            if headerHeightToUse >= 250 {
                headerContainerViewHeight?.constant = 250
            } else if headerHeightToUse <= 50 {
                headerContainerViewHeight?.constant = 50
            } else {
                headerContainerViewHeight?.constant = headerHeightToUse
            }
            self.view.layoutIfNeeded()
        }
    }
    
    let headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    let mainContentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2000
        return stackView
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
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .systemBackground
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        configureBottomToolBar()
        setupViews()
        loadDataUsing(city: getCityFromUserDefaults())
    }
    
    private func configureBottomToolBar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton))
        let refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))
        
        toolbarItems = [plusButton, spacer, refreshButton]
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func setupViews() {
        view.addSubview(headerContainerView)
        headerContainerView.addSubview(selectedLocation)
        headerContainerView.addSubview(tempLabel)
        headerContainerView.addSubview(tempDescription)
        
        view.addSubview(mainContentScrollView)
        mainContentScrollView.delegate = self
        
        mainContentScrollView.addSubview(contentMainStackView)
        
        headerContainerViewHeight = headerContainerView.heightAnchor.constraint(equalToConstant: 250)
        
        let constraints = [
            headerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerContainerViewHeight!,
            
            selectedLocation.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 20),
            selectedLocation.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 18),
            selectedLocation.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -18),

            tempLabel.topAnchor.constraint(equalTo: selectedLocation.bottomAnchor, constant: 20),
            tempLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 18),
            tempLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -18),

            tempDescription.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 12.5),
            tempDescription.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 18),
            tempDescription.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -18),
            tempDescription.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -8),
            
            mainContentScrollView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            mainContentScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainContentScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainContentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentMainStackView.topAnchor.constraint(equalTo: mainContentScrollView.topAnchor, constant: 20),
            contentMainStackView.leadingAnchor.constraint(equalTo: mainContentScrollView.leadingAnchor, constant: 10),
            contentMainStackView.trailingAnchor.constraint(equalTo: mainContentScrollView.trailingAnchor, constant: -10),
            contentMainStackView.bottomAnchor.constraint(equalTo: mainContentScrollView.bottomAnchor, constant: -20),
            contentMainStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let viewsToAdd = [minTemp, maxTemp]
        for view in viewsToAdd {
            contentMainStackView.addArrangedSubview(view)
        }
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
    }
    
    private func dismissSpinner() {
        spinnerView.willMove(toParent: nil)
        spinnerView.view.removeFromSuperview()
        spinnerView.removeFromParent()
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

// MARK: - UIScrollViewDelegate
extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        
        let newHeaderViewHeight: CGFloat = headerHeightToUse - y
        
        headerHeightToUse = newHeaderViewHeight
        if newHeaderViewHeight > 250.0 {
            headerHeightToUse = 250
        } else if newHeaderViewHeight < 50.0 {
            headerHeightToUse = 50
        } else {
            headerHeightToUse = newHeaderViewHeight
            scrollView.contentOffset.y = 0
        }
    }
}
