//
//  CitiesSelectorViewController.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

protocol CitiesSelectorViewControllerDelegate: AnyObject {
    func citiesSelectorGoingToClose(cityToUpdate: City?)
}

class CitiesSelectorViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - UI
    let spinnerView = SpinnerView()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Contants
    let viewModel = WeatherViewModel()
    
    weak var delegate: CitiesSelectorViewControllerDelegate?
    
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SelectCityTableViewCell.self, forCellReuseIdentifier: SelectCityTableViewCell.selectedCityCVIdentifier)
        
        configureMainView()
        configureFooterView()
    }
    
    func configureMainView() {
        view.addSubview(tableView)
        
        let mainConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(mainConstraints)
    }
    
    func configureFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        footerView.backgroundColor = .clear
        
        let addCityButton = UIButton()
        let buttonImage = UIImage(systemName: "plus.circle")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        addCityButton.setImage(buttonImage, for: .normal)
        addCityButton.addTarget(self, action: #selector(handleAddCity), for: .touchUpInside)
        addCityButton.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(addCityButton)
        
        let footerContraints = [
            addCityButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            addCityButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -8),
            addCityButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8),
            addCityButton.widthAnchor.constraint(equalToConstant: 30)
        ]

        NSLayoutConstraint.activate(footerContraints)
        
        tableView.tableFooterView = footerView
    }
    
    //MARK: - Actions
    @objc func handleAddCity() {
        showAlertForAddCity()
    }
    
    private func showAlertForAddCity() {
        let titleToUse = "Add City"
        let actionTextToUse = "Add"
        
        let alertController = UIAlertController(title: titleToUse, message: nil, preferredStyle: .alert)
           alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "City Name"
        }
        
        let saveAction = UIAlertAction(title: actionTextToUse, style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let cityname = firstTextField.text else { return }
            
            self.loadDataUsing(cityName: cityname)
        })
          
       let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
          print("Cancel")
       })
    

       alertController.addAction(saveAction)
       alertController.addAction(cancelAction)

       present(alertController, animated: true, completion: nil)
    }
    
    func loadDataUsing(cityName: String) {
        showSpinner()
        
        if let savedCity = viewModel.currentCity, cityName.capitalized == savedCity.name.capitalized {
            viewModel.fetchWeatherUsing(lat: savedCity.latitude, lon: savedCity.longitude) { [weak self] weather in
                if let currentWeater = weather.currentWeather {
                    let location = Location(id: savedCity.id, name: savedCity.name, state: savedCity.state, country: savedCity.country, lat: savedCity.latitude, long: savedCity.longitude)
                    self?.viewModel.saveWeatherForCity(cityForWeather: location, weatherFromServer: currentWeater)
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.dismissSpinner()
                    }
                }
            }
            
            dismissSpinner()
            return
        }
        
        DispatchQueue.main.async {
            if let location = self.viewModel.returnLocationFromJSONFile(cityName: cityName) {
                self.viewModel.fetchWeatherUsing(lat: location.lat, lon: location.long) { [weak self] weather in
                    self?.viewModel.saveCityToDB(locationToSave: location, cityToSave: nil)
                    
                    if let currentWeater = weather.currentWeather {
                        self?.viewModel.saveWeatherForCity(cityForWeather: location, weatherFromServer: currentWeater)
                        
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                            self?.dismissSpinner()
                        }
                    }
                }
            } else {
                self.dismissSpinner()
            }
        }
    }
    
    private func showSpinner() {
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
        spinnerView.isHidden = true
        spinnerView.spinner.stopAnimating()
        spinnerView.removeFromSuperview()
    }
}

//MARK: - UITableView
extension CitiesSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.publicSavedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SelectCityTableViewCell.selectedCityCVIdentifier, for: indexPath) as? SelectCityTableViewCell, let city = viewModel.publicSavedCities[safe: indexPath.row] {
            
            cell.currentCityNameLabel.text = city.name
            
            //TODO make a network call if there is no weather data
            let cityTemperature = city.currentWeather?.temperature ?? 0
            cell.currentCityTemperatureLabel.text = String(format: "%.0f", cityTemperature) + "°"
            
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let city = viewModel.publicSavedCities[safe: indexPath.row], city != viewModel.currentCity {
            delegate?.citiesSelectorGoingToClose(cityToUpdate: city)
        } else {
            delegate?.citiesSelectorGoingToClose(cityToUpdate: nil)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
