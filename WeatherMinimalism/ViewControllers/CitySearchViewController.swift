//
//  CitySearchViewController.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/18/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class CitySearchViewController: UIViewController {
    
    //MARK: - UI
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        return searchController
    }()
    
    //MARK: - Contants
    let viewModel = WeatherViewModel()
    
    var filteredLocations: [Location] = []
    
    var timer = Timer()
    
    var one = 0
    var two = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
//        definesPresentationContext = true
        
        configureMainView()
    }
    
    //MARK: - UI Actions
    func configureMainView() {
        view.addSubview(tableView)
        
        let mainConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(mainConstraints)
        
        tableView.tableHeaderView = searchController.searchBar
    }
}

//MARK: - UISearchResultsUpdating
extension CitySearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            timer.invalidate()
            if searchText.count > 1 {
                timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(searchForCities(sender:)), userInfo: searchText, repeats: false)
            } else {
                filteredLocations.removeAll()
                
                tableView.reloadData()
            }
        }
    }
    
    @objc func searchForCities(sender: Timer) {
        guard let searchText = sender.userInfo as? String else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            self.filteredLocations = self.viewModel.returnLocationsFromJSONFile(cityName: searchText)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - UITableView
extension CitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = filteredLocations[safe: indexPath.row]?.name
        return cell
    }
}
