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
    
    var next24HoursArray: [String] = []
    
    var locationManager = CLLocationManager()
    
    var headerHeightToUse: CGFloat = 250 {
        didSet {
            if headerHeightToUse >= 250 {
                headerContainerViewHeight?.constant = 250
                headerContainerView.tempLabel.textColor = UIColor.label.withAlphaComponent(1.0)
            } else if headerHeightToUse <= 90 {
                headerContainerViewHeight?.constant = 90
                headerContainerView.tempLabel.textColor = UIColor.label.withAlphaComponent(0.0)
            } else {
                headerContainerViewHeight?.constant = headerHeightToUse
                
                let alphaPercentToUse = (headerHeightToUse - 100) / 100
                headerContainerView.tempLabel.textColor = UIColor.label.withAlphaComponent(alphaPercentToUse)
            }
            view.layoutIfNeeded()
        }
    }
    
    //MARK: - UI
    let spinnerView = SpinnerView()
    let headerContainerView = HeaderContainerView()
    let minMaxTempContainerView = MinMaxContainerView()
    let todayHourlyWeatherCVContainer = TodayHourlyWeatherCVView()
    let dailyForecastForWeekSVContainer = DailyForecastForWeekSVView()
    let currentDayOverviewContainer = CurrentDayOverviewView()
    let todayDetailedOverviewContainer = TodayDetailedOverviewView()
    
    var headerContainerViewHeight: NSLayoutConstraint?
    
    let mainContentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
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
        
        next24HoursArray = Date().next24Hours()
        
        self.viewModel.loadCitiesFromDB()
        
        configureBottomToolBar()
        setupViews()
        selectRoadToMakeInitialCall()
    }
    
    private func configureBottomToolBar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let citiesButton = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(showCitiesSelectorView))
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton))
        let refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))
        
        toolbarItems = [plusButton, refreshButton, spacer, citiesButton]
        
        navigationController?.toolbar.barTintColor = .systemBackground
        navigationController?.toolbar.isTranslucent = false
        
        toggleToolbarHidden(isHidden: false)
    }
    
    func setupViews() {
        configureMainView()
        
        contentMainStackView.addArrangedSubview(minMaxTempContainerView)
        
        todayHourlyWeatherCVContainer.todayHourlyWeatherCollectionView.dataSource = self
        todayHourlyWeatherCVContainer.todayHourlyWeatherCollectionView.delegate = self
        contentMainStackView.addArrangedSubview(todayHourlyWeatherCVContainer)
        
        contentMainStackView.addArrangedSubview(dailyForecastForWeekSVContainer)
        
        contentMainStackView.addArrangedSubview(currentDayOverviewContainer)
        
        contentMainStackView.addArrangedSubview(todayDetailedOverviewContainer)
    }
    
    func configureMainView() {
        view.addSubview(headerContainerView)
        
        view.addSubview(mainContentScrollView)
        mainContentScrollView.delegate = self
        
        mainContentScrollView.addSubview(contentMainStackView)
        
        headerContainerViewHeight = headerContainerView.heightAnchor.constraint(equalToConstant: 250)
        
        let mainConstraints = [
            headerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerContainerViewHeight!,
            
            mainContentScrollView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            mainContentScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainContentScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainContentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentMainStackView.topAnchor.constraint(equalTo: mainContentScrollView.topAnchor, constant: 10),
            contentMainStackView.leadingAnchor.constraint(equalTo: mainContentScrollView.leadingAnchor, constant: 0),
            contentMainStackView.trailingAnchor.constraint(equalTo: mainContentScrollView.trailingAnchor, constant: 0),
            contentMainStackView.bottomAnchor.constraint(equalTo: mainContentScrollView.bottomAnchor, constant: 0),
            contentMainStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(mainConstraints)
    }
    
    private func selectRoadToMakeInitialCall() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                //will get data from didUpdateLocations method
                showSpinner()
                return
            default:
                //do not have location services, so let's check user defaults
                break
            }
        }
        
        if let city = viewModel.currentCity {
            loadDataUsing(lat: city.latitude, lon: city.longitude)
        } else {
            showAlertForAddCity(title: "Add Your City", message: "In order to get weather conditions you need to type a city name", actionText: "Add")
        }
    }
    
    //MARK: - Actions
    func loadDataUsing(city: String) {
        showSpinner()
        
        if let savedCity = viewModel.currentCity, city.capitalized == savedCity.name.capitalized {
            viewModel.fetchWeatherUsing(lat: savedCity.latitude, lon: savedCity.longitude) { [weak self] weather in
                if let currentWeater = weather.currentWeather {
                    let location = Location(id: savedCity.id, name: savedCity.name, state: savedCity.state, country: savedCity.country, lat: savedCity.latitude, long: savedCity.longitude)
                    self?.viewModel.saveWeatherForCity(cityForWeather: location, weatherFromServer: currentWeater)
                }
                
                self?.updateUIWith(weather: weather)
            }
            return
        }
        
        DispatchQueue.main.async {
            if let location = self.viewModel.returnLocationFromJSONFile(cityName: city) {
                self.viewModel.fetchWeatherUsing(lat: location.lat, lon: location.long) { [weak self] weather in
                    self?.viewModel.saveCityToDB(locationToSave: location, cityToSave: nil)
                    
                    if let currentWeater = weather.currentWeather {
                        self?.viewModel.saveWeatherForCity(cityForWeather: location, weatherFromServer: currentWeater)
                    }
                    
                    self?.updateUIWith(weather: weather)
                }
            } else {
                self.dismissSpinner()
            }
        }
    }
    
    func loadDataUsing(lat: Double, lon: Double) {
        showSpinner()
        
        if let savedCity = viewModel.currentCity, lat.returnAsOneDigitPrecision == savedCity.latitude.returnAsOneDigitPrecision && lon.returnAsOneDigitPrecision == savedCity.longitude.returnAsOneDigitPrecision {
            viewModel.fetchWeatherUsing(lat: lat, lon: lon) { [weak self] weather in
                if let currentWeater = weather.currentWeather {
                    let location = Location(id: savedCity.id, name: savedCity.name, state: savedCity.state, country: savedCity.country, lat: savedCity.latitude, long: savedCity.longitude)
                    self?.viewModel.saveWeatherForCity(cityForWeather: location, weatherFromServer: currentWeater)
                }
                
                self?.updateUIWith(weather: weather)
            }
            return
        }
        
        DispatchQueue.main.async {
            var locationToUse: Location?
            
            if let nonEmptyLocationFromJSON = self.viewModel.returnLocationFromJSONFile(lat: lat, long: lon) {
                locationToUse = nonEmptyLocationFromJSON
                self.viewModel.saveCityToDB(locationToSave: nonEmptyLocationFromJSON, cityToSave: nil)
            }
            
            self.viewModel.fetchWeatherUsing(lat: lat, lon: lon) { [weak self] weather in
                if let location = locationToUse, let currentWeater = weather.currentWeather {
                    self?.viewModel.saveWeatherForCity(cityForWeather: location, weatherFromServer: currentWeater)
                }
                
                self?.updateUIWith(weather: weather)
            }
        }
    }
    
    func updateUIWith(weather: Forecast) {
        DispatchQueue.main.async {
            self.fillUpHeaderContainerView(currentWeather: weather.currentWeather)
            
            self.fillUpMinMaxTempContainerView(dailyTemperature: weather.dailyWeather?.first?.dailyTemperature)
            
            self.todayHourlyWeatherCVContainer.todayHourlyWeatherCollectionView.reloadData()
            
            self.fillUpWeeklyForecastStackView()
            
            self.fillUpCurrentDayOverview()
            
            self.fillUpTodayDetailedOverview()
            
            self.dismissSpinner()
        }
    }
    
    private func fillUpHeaderContainerView(currentWeather: WeatherForTimeSlice?) {
        if let savedCity = viewModel.currentCity {
            headerContainerView.selectedLocation.text = savedCity.name.capitalized
        }
        
        headerContainerView.tempDescription.text = currentWeather?.weatherDetails?.first?.description
        if let nonEmtyTemp = currentWeather?.temperature {
            headerContainerView.tempLabel.text = String(format: "%.0f", nonEmtyTemp) + "°"
        }
    }
    
    private func fillUpMinMaxTempContainerView(dailyTemperature: DailyTemperature?) {
        minMaxTempContainerView.dayOfTheWeekLabel.text = Date().dayOfWeekByString()
        
        if let minTemp = dailyTemperature?.min, let maxTemp = dailyTemperature?.max {
            minMaxTempContainerView.minTemp.text = String(format: "%.0f", minTemp) + "°"
            minMaxTempContainerView.maxTemp.text = String(format: "%.0f", maxTemp) + "°"
        }
    }
    
    private func fillUpWeeklyForecastStackView() {
        guard let nonEmptyDailyWeather = viewModel.publicWeatherData?.dailyWeather else { return }
        
        let weekdaysArray = Date().daysOfWeekArray()
        
        for (index, weather) in nonEmptyDailyWeather.enumerated() {
            if let weatherIcon = weather.weatherDetails?.first?.icon, let maxTemp = weather.dailyTemperature?.max, let minTemp = weather.dailyTemperature?.min {
                let dailyWeatherView = DailyForecastForWeekView(frame: CGRect.zero)
                
                dailyWeatherView.dayOfTheWeekLabel.text = weekdaysArray[safe: index] as? String
                dailyWeatherView.weatherForDayImageView.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weatherIcon)@2x.png")
                dailyWeatherView.maxTempLabel.text = String(format: "%.0f", maxTemp)
                dailyWeatherView.minTemp.text = String(format: "%.0f", minTemp)
                
                dailyForecastForWeekSVContainer.dailyForecastForWeekStackView.addArrangedSubview(dailyWeatherView)
            }
        }
    }
    
    private func fillUpCurrentDayOverview() {
        guard let nonEmptyWeather = viewModel.publicWeatherData?.dailyWeather?.first else { return }
        
        let maxTemp = nonEmptyWeather.dailyTemperature?.max ?? 0
        let minTemp = nonEmptyWeather.dailyTemperature?.min ?? 0
        let currentWeatherDescription = nonEmptyWeather.weatherDetails?.first?.detailedDescription ?? ""

        let finalText = "Today: \(currentWeatherDescription.lowercased()). The high will be \(String(format: "%.0f", maxTemp))°. The low will be \(String(format: "%.0f", minTemp))°."
        currentDayOverviewContainer.currentDayOverviewLabel.text = finalText
    }
    
    private func fillUpTodayDetailedOverview() {
        guard let nonEmptyWeather = viewModel.publicWeatherData?.currentWeather else { return }
        
        //first row
        let sunriseView = TodayDetailedOverviewContentView()
        sunriseView.titleLabel.text = "Sunrise"
        sunriseView.dataLabel.text = nonEmptyWeather.sunriseTimestamp?.timestampAsStringedHourMinuteForCurrentTimeZone ?? ""
        
        let sunsetView = TodayDetailedOverviewContentView()
        sunsetView.titleLabel.text = "Sunset"
        sunsetView.dataLabel.text = nonEmptyWeather.sunsetTimestamp?.timestampAsStringedHourMinuteForCurrentTimeZone ?? ""
        
        let sunsetSunriseStackView = TodayDetailedOverviewHorizontalSVView()
        sunsetSunriseStackView.todayDetailedOverviewHorizontalStackView.addArrangedSubview(sunriseView)
        sunsetSunriseStackView.todayDetailedOverviewHorizontalStackView.addArrangedSubview(sunsetView)
        
        //second row
        let humidityView = TodayDetailedOverviewContentView()
        humidityView.titleLabel.text = "Humidity"
        humidityView.dataLabel.text = String(format: "%.0f", nonEmptyWeather.humidity ?? 0) + "%"
        
        let feelsLikeView = TodayDetailedOverviewContentView()
        feelsLikeView.titleLabel.text = "Feels Like"
        feelsLikeView.dataLabel.text = String(format: "%.0f", nonEmptyWeather.feelsLike ?? 0) + "°"
        
        let humidityFeelslikeStackView = TodayDetailedOverviewHorizontalSVView()
        humidityFeelslikeStackView.todayDetailedOverviewHorizontalStackView.addArrangedSubview(humidityView)
        humidityFeelslikeStackView.todayDetailedOverviewHorizontalStackView.addArrangedSubview(feelsLikeView)
        
        //third row
        let visibilityView = TodayDetailedOverviewContentView()
        visibilityView.titleLabel.text = "Visibility"
        visibilityView.dataLabel.text = String(format: "%.0f", nonEmptyWeather.visibility?.convertMetersIntoKilometers ?? 0) + " km"
        
        let uvIndexView = TodayDetailedOverviewContentView()
        uvIndexView.titleLabel.text = "UV Index"
        uvIndexView.dataLabel.text = String(format: "%.0f", nonEmptyWeather.uvIndex ?? 0)
        
        let visibilityUVIndextackView = TodayDetailedOverviewHorizontalSVView()
        visibilityUVIndextackView.todayDetailedOverviewHorizontalStackView.addArrangedSubview(visibilityView)
        visibilityUVIndextackView.todayDetailedOverviewHorizontalStackView.addArrangedSubview(uvIndexView)
        
        //final setup
        todayDetailedOverviewContainer.todayDetailedOverviewMainStackView.addArrangedSubview(sunsetSunriseStackView)
        todayDetailedOverviewContainer.todayDetailedOverviewMainStackView.addArrangedSubview(humidityFeelslikeStackView)
        todayDetailedOverviewContainer.todayDetailedOverviewMainStackView.addArrangedSubview(visibilityUVIndextackView)
    }
    
    private func toggleToolbarHidden(isHidden: Bool) {
        navigationController?.setToolbarHidden(isHidden, animated: false)
    }
    
    private func showSpinner() {
        toggleToolbarHidden(isHidden: true)
        spinnerView.isHidden = false
        spinnerView.spinner.startAnimating()
        
        view.addSubview(spinnerView)
        
        let constraints = [
            spinnerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            spinnerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func dismissSpinner() {
        toggleToolbarHidden(isHidden: false)
        
        spinnerView.isHidden = true
        spinnerView.spinner.stopAnimating()
        spinnerView.removeFromSuperview()
    }
    
    @objc func handleAddPlaceButton() {
        showAlertForAddCity(title: nil, message: nil, actionText: nil)
    }
    
    private func showAlertForAddCity(title: String?, message: String?, actionText: String?) {
        let titleToUse = title ?? "Change City"
        let messageToUse = message ?? ""
        let actionTextToUse = actionText ?? "Change"
        
        let alertController = UIAlertController(title: titleToUse, message: messageToUse, preferredStyle: .alert)
           alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "City Name"
        }
        
        let saveAction = UIAlertAction(title: actionTextToUse, style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let cityname = firstTextField.text else { return }
            
            self.loadDataUsing(city: cityname)
        })
          
       let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
          print("Cancel")
       })
    

       alertController.addAction(saveAction)
       alertController.addAction(cancelAction)

       present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleRefresh() {
        if let savedCity = viewModel.currentCity {
            loadDataUsing(lat: savedCity.latitude, lon: savedCity.longitude)
        }
    }
    
    @objc func showCitiesSelectorView() {
        let citiesSelectionVC = CitiesSelectorViewController()
        citiesSelectionVC.delegate = self
        self.present(citiesSelectionVC, animated: true, completion: nil)
    }
}

// MARK: - Extensions
// MARK: - UIScrollViewDelegate
extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        
        let newHeaderViewHeight: CGFloat = headerHeightToUse - y
        
        headerHeightToUse = newHeaderViewHeight
        if newHeaderViewHeight > 250.0 {
            headerHeightToUse = 250
        } else if newHeaderViewHeight < 90.0 {
            headerHeightToUse = 90
        } else {
            headerHeightToUse = newHeaderViewHeight
            scrollView.contentOffset.y = 0
        }
    }
}

// MARK: - UICollectionView
extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.publicWeatherData?.publicHourlyWeather.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayHourlyWeatherCVCell.identifier, for: indexPath) as! TodayHourlyWeatherCVCell
        
        if let weatherData = viewModel.publicWeatherData?.publicHourlyWeather[safe: indexPath.row], let weatherDataDetails = weatherData.weatherDetails?.first {
            
            if let hourForCell = next24HoursArray[safe: indexPath.row] {
                cell.timeLabel.text = hourForCell
            } else {
                cell.timeLabel.text = weatherDataDetails.description
            }
            
            if let nonEmptyIcon = weatherDataDetails.icon {
                cell.weatherIcon.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(nonEmptyIcon)@2x.png")
            } else {
                cell.weatherIcon.image = nil
            }
            
            if let nonEmptyTemp = weatherData.temperature {
                cell.temperatureLabel.text = String(format: "%.0f", nonEmptyTemp) + "°"
            } else {
                cell.temperatureLabel.text = nil
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let todayHourlyWeatherCVInset = collectionView.contentInset
        let cellHeight = collectionView.bounds.height - todayHourlyWeatherCVInset.bottom - todayHourlyWeatherCVInset.top
        
        return CGSize(width: 80, height: cellHeight)
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
        guard let location = locations[safe: 0]?.coordinate else { return }
        loadDataUsing(lat: location.latitude, lon: location.longitude)
    }
}

extension WeatherViewController: CitiesSelectorViewControllerDelegate {
    func citiesSelectorGoingToClose(needToUpdate: Bool) {
        if needToUpdate {
            handleRefresh()
        }
    }
}
