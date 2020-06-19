//
//  CitySearchViewController.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/18/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

enum SearchState: String {
    case showingResults
    case searching = "Validating city..."
    case noResult = "No results found."
    case empty = ""
}

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
    var searchState: SearchState = .empty {
        didSet {
            handleSearchStateChange()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        
        configureMainView()
    }
    
    //MARK: - Actions
    func handleSearchStateChange() {
        switch searchState {
        case .empty:
            print("empty")
        case .noResult:
            print("no result")
        case .searching:
            print("searching")
        case .showingResults:
            print("showing results")
        }
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
                searchState = .searching
                timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(searchForCities(sender:)), userInfo: searchText, repeats: false)
            } else {
                searchState = .empty
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
                if self.searchController.searchBar.text?.count ?? 0 >= searchText.count {
                    self.searchState = self.filteredLocations.isEmpty ? .noResult : .showingResults
                    self.tableView.reloadData()
                } else {
                    self.searchState = .empty
                }
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
        var finalCityString = ""
        
        if let location = filteredLocations[safe: indexPath.row] {
            finalCityString = location.name
            
            if location.state != "" {
                finalCityString += ", \(location.state)"
            }
            
            if location.country != "" {
                finalCityString += ", \(location.country)"
            }
        }
        
        cell.textLabel?.text = finalCityString
        
        return cell
    }
}
