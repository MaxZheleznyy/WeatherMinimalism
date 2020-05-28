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
    
    var headerContainerViewHeight: NSLayoutConstraint?
    
    var headerHeightToUse: CGFloat = 250 {
        didSet {
            if headerHeightToUse >= 250 {
                headerContainerViewHeight?.constant = 250
                tempLabel.textColor = UIColor.label.withAlphaComponent(1.0)
            } else if headerHeightToUse <= 90 {
                headerContainerViewHeight?.constant = 90
                tempLabel.textColor = UIColor.label.withAlphaComponent(0.0)
            } else {
                headerContainerViewHeight?.constant = headerHeightToUse
                
                let alphaPercentToUse = (headerHeightToUse - 100) / 100
                tempLabel.textColor = UIColor.label.withAlphaComponent(alphaPercentToUse)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - UI
    let spinnerView = SpinnerViewController()
    
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
    
    let headerContainerView: UIView = {
        let view = UIView()
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
    
    let tempDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 80, weight: .medium)
        return label
    }()
    
    let minMaxTempContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dayOfTheWeekLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let todayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TODAY"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let maxTemp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let minTemp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let todayHourlyWeatherCVContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let todayHourlyWeatherCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        return collectionView
    }()
    
    let dailyForecastForWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
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
        
        configureBottomToolBar()
        setupViews()
        selectRoadToMakeInitialCall()
    }
    
    private func configureBottomToolBar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton))
        let refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))
        
        toolbarItems = [plusButton, spacer, refreshButton]
        
        navigationController?.toolbar.barTintColor = .systemBackground
        navigationController?.toolbar.isTranslucent = false
        
        toggleToolbarHidden(isHidden: false)
    }
    
    func setupViews() {
        configureMainView()
        configureMinMaxTempView()
        configureCollectionView()
        
        self.contentMainStackView.addArrangedSubview(dailyForecastForWeekStackView)
    }
    
    func configureMainView() {
        view.addSubview(headerContainerView)
        headerContainerView.addSubview(selectedLocation)
        headerContainerView.addSubview(tempLabel)
        headerContainerView.addSubview(tempDescription)
        
        view.addSubview(mainContentScrollView)
        mainContentScrollView.delegate = self
        
        mainContentScrollView.addSubview(contentMainStackView)
        
        headerContainerViewHeight = headerContainerView.heightAnchor.constraint(equalToConstant: 250)
        
        let mainConstraints = [
            headerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerContainerViewHeight!,
            
            selectedLocation.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 20),
            selectedLocation.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 18),
            selectedLocation.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -18),
            
            tempDescription.topAnchor.constraint(equalTo: selectedLocation.bottomAnchor, constant: 0),
            tempDescription.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 18),
            tempDescription.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -18),

            tempLabel.topAnchor.constraint(lessThanOrEqualTo: tempDescription.bottomAnchor, constant: 0),
            tempLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 18),
            tempLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -18),
            tempLabel.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -8),
            
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
        
        selectedLocation.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tempDescription.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tempLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate(mainConstraints)
    }
    
    func configureMinMaxTempView() {
        
        let bottomDividerView = minMaxTempContainerView.addBottomDividerView()
        
        minMaxTempContainerView.addSubview(dayOfTheWeekLabel)
        minMaxTempContainerView.addSubview(todayLabel)
        minMaxTempContainerView.addSubview(maxTemp)
        minMaxTempContainerView.addSubview(minTemp)
        
        let minMaxViewConstrainsts = [
            minMaxTempContainerView.widthAnchor.constraint(equalTo: contentMainStackView.widthAnchor),
            
            dayOfTheWeekLabel.topAnchor.constraint(equalTo: minMaxTempContainerView.topAnchor),
            dayOfTheWeekLabel.leadingAnchor.constraint(equalTo: minMaxTempContainerView.leadingAnchor, constant: 16),
            dayOfTheWeekLabel.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -8),
            
            todayLabel.topAnchor.constraint(equalTo: minMaxTempContainerView.topAnchor),
            todayLabel.leadingAnchor.constraint(equalTo: dayOfTheWeekLabel.trailingAnchor, constant: 8),
            todayLabel.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -8),
            
            maxTemp.topAnchor.constraint(equalTo: minMaxTempContainerView.topAnchor),
            maxTemp.leadingAnchor.constraint(equalTo: todayLabel.trailingAnchor, constant: 20),
            maxTemp.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -8),
            
            minTemp.topAnchor.constraint(equalTo: minMaxTempContainerView.topAnchor),
            minTemp.leadingAnchor.constraint(equalTo: maxTemp.trailingAnchor, constant: 8),
            minTemp.trailingAnchor.constraint(equalTo: minMaxTempContainerView.trailingAnchor, constant: -16),
            minTemp.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -8)
        ]
        
        dayOfTheWeekLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        todayLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        maxTemp.setContentHuggingPriority(.defaultLow, for: .horizontal)
        minTemp.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        contentMainStackView.addArrangedSubview(minMaxTempContainerView)
        
        NSLayoutConstraint.activate(minMaxViewConstrainsts)
    }
    
    func configureCollectionView() {
        todayHourlyWeatherCollectionView.register(TodayHourlyWeatherCVCell.self, forCellWithReuseIdentifier: TodayHourlyWeatherCVCell.identifier)
        todayHourlyWeatherCollectionView.dataSource = self
        todayHourlyWeatherCollectionView.delegate = self
        
        let bottomDividerView = todayHourlyWeatherCVContainer.addBottomDividerView()
        
        todayHourlyWeatherCVContainer.addSubview(todayHourlyWeatherCollectionView)
        
        contentMainStackView.addArrangedSubview(todayHourlyWeatherCVContainer)
        
        let todayHourlyWeatherCollectionViewConstrainsts = [
            todayHourlyWeatherCVContainer.heightAnchor.constraint(equalToConstant: 110),
            
            todayHourlyWeatherCollectionView.topAnchor.constraint(equalTo: todayHourlyWeatherCVContainer.topAnchor),
            todayHourlyWeatherCollectionView.leadingAnchor.constraint(equalTo: todayHourlyWeatherCVContainer.leadingAnchor),
            todayHourlyWeatherCollectionView.trailingAnchor.constraint(equalTo: todayHourlyWeatherCVContainer.trailingAnchor),
            todayHourlyWeatherCollectionView.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(todayHourlyWeatherCollectionViewConstrainsts)
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
        
        if let location = viewModel.getCityFromUserDefauts() {
            loadDataUsing(lat: location.lat, lon: location.long)
        } else {
            showAlertForAddCity(title: "Add Your City", message: "In order to get weather conditions you need to type a city name", actionText: "Add")
        }
    }
    
    //MARK: - Actions
    func loadDataUsing(city: String) {
        showSpinner()
        
        if let locationFromUserDefaults = viewModel.getCityFromUserDefauts(), city.capitalized == locationFromUserDefaults.name.capitalized {
            
            viewModel.fetchWeatherUsing(lat: locationFromUserDefaults.lat, lon: locationFromUserDefaults.long) { [weak self] weather in
                self?.updateUIWith(weather: weather)
            }
            return
            
        }
        
        DispatchQueue.main.async {
            if let location = self.viewModel.returnLocationFromJSONFile(cityName: city) {
                self.viewModel.fetchWeatherUsing(lat: location.lat, lon: location.long) { [weak self] weather in
                    self?.viewModel.saveNewCityToUserDefaults(location: location)
                    self?.updateUIWith(weather: weather)
                }
            } else {
                self.dismissSpinner()
            }
        }
    }
    
    func loadDataUsing(lat: Double, lon: Double) {
        showSpinner()
        
        if let locationFromUserDefaults = viewModel.getCityFromUserDefauts(), lat.returnAsOneDigitPrecision == locationFromUserDefaults.lat.returnAsOneDigitPrecision && lon.returnAsOneDigitPrecision == locationFromUserDefaults.long.returnAsOneDigitPrecision {
            
            viewModel.fetchWeatherUsing(lat: lat, lon: lon) { [weak self] weather in
                self?.updateUIWith(weather: weather)
            }
            return
            
        }
        
        DispatchQueue.main.async {
            if let nonEmptyLocationFromJSON = self.viewModel.returnLocationFromJSONFile(lat: lat, long: lon) {
                self.viewModel.saveNewCityToUserDefaults(location: nonEmptyLocationFromJSON)
            }
            
            self.viewModel.fetchWeatherUsing(lat: lat, lon: lon) { [weak self] weather in
                self?.updateUIWith(weather: weather)
            }
        }
    }
    
    func updateUIWith(weather: Forecast) {
        DispatchQueue.main.async {
            self.fillUpHeaderContainerView(currentWeather: weather.currentWeather)
            
            self.fillUpMinMaxTempContainerView(dailyTemperature: weather.dailyWeather?.first?.dailyTemperature)
            
            self.todayHourlyWeatherCollectionView.reloadData()
            
            self.fillUpWeeklyForecastStackView()
            
            self.dismissSpinner()
        }
    }
    
    private func fillUpHeaderContainerView(currentWeather: WeatherForTimeSlice?) {
        if let cityFromUD = self.viewModel.getCityFromUserDefauts() {
            var finalString = cityFromUD.name.capitalized
            if cityFromUD.state != "" {
                finalString += ", \(cityFromUD.state.uppercased())"
            }
            self.selectedLocation.text = finalString
        }
        
        self.tempDescription.text = currentWeather?.weatherDetails?.first?.description
        if let nonEmtyTemp = currentWeather?.temperature {
            self.tempLabel.text = String(format:"%.0f", nonEmtyTemp) + "°"
        }
    }
    
    private func fillUpMinMaxTempContainerView(dailyTemperature: DailyTemperature?) {
        self.dayOfTheWeekLabel.text = Date().dayOfWeekByString()
        
        if let minTemp = dailyTemperature?.min, let maxTemp = dailyTemperature?.max {
            self.minTemp.text = String(format:"%.0f", minTemp) + "°"
            self.maxTemp.text = String(format:"%.0f", maxTemp) + "°"
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
                dailyWeatherView.maxTempLabel.text = String(format:"%.0f", maxTemp)
                dailyWeatherView.minTemp.text = String(format:"%.0f", minTemp)
                
                self.dailyForecastForWeekStackView.addArrangedSubview(dailyWeatherView)
            }
        }
    }
    
    private func toggleToolbarHidden(isHidden: Bool) {
        navigationController?.setToolbarHidden(isHidden, animated: false)
    }
    
    private func showSpinner() {
        toggleToolbarHidden(isHidden: true)
        
        addChild(spinnerView)
        spinnerView.view.frame = view.frame
        view.addSubview(spinnerView.view)
        spinnerView.didMove(toParent: self)
    }
    
    private func dismissSpinner() {
        toggleToolbarHidden(isHidden: false)

        spinnerView.willMove(toParent: nil)
        spinnerView.view.removeFromSuperview()
        spinnerView.removeFromParent()
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

           self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleRefresh() {
        if let location = viewModel.getCityFromUserDefauts() {
            loadDataUsing(lat: location.lat, lon: location.long)
        }
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
        return viewModel.publicWeatherData?.hourlyWeather?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayHourlyWeatherCVCell.identifier, for: indexPath) as! TodayHourlyWeatherCVCell
        
        if let weatherData = viewModel.publicWeatherData?.hourlyWeather?[safe: indexPath.row], let weatherDataDetails = weatherData.weatherDetails?.first {
            cell.timeLabel.text = weatherDataDetails.description
            
            if let nonEmptyIcon = weatherDataDetails.icon {
                cell.weatherIcon.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(nonEmptyIcon)@2x.png")
            }
            
            if let nonEmptyTemp = weatherData.temperature {
                cell.temperatureLabel.text = String(format:"%.0f", nonEmptyTemp) + "°"
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
