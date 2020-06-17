//
//  CitiesSelectorViewController.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

protocol CitiesSelectorViewControllerDelegate: AnyObject {
    func citiesSelectorGoingToClose(needToUpdate: Bool)
}

class CitiesSelectorViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - UI
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Contants
    let viewModel = WeatherViewModel()
    
    weak var delegate: CitiesSelectorViewControllerDelegate?
    
    private var needToUpdate: Bool = false
    
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SelectCityTableViewCell.self, forCellReuseIdentifier: SelectCityTableViewCell.selectedCityCVIdentifier)
        
        configureMainView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            delegate?.citiesSelectorGoingToClose(needToUpdate: needToUpdate)
        }
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
        
        tableView.tableFooterView = UIView()
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
        if let city = viewModel.publicSavedCities[safe: indexPath.row] {
            print(city.name)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
