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

protocol CitySearchViewControllerDelegate: AnyObject {
    func updateCitiesList(location: Location)
}

class CitySearchViewController: UIViewController {
    
    //MARK: - UI
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsMultipleSelection = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        return searchController
    }()
    
    //MARK: - Contants
    let viewModel = WeatherViewModel()
    var filteredLocations: [Location] = []
    var timer = Timer()
    
    weak var delegate: CitySearchViewControllerDelegate?
    
    var searchState: SearchState = .empty {
        didSet {
            handleSearchStateChange()
        }
    }
    
    var showPlaceholderText = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        configureMainView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
    }
    
    //MARK: - Actions
    func handleSearchStateChange() {
        switch searchState {
        case .empty:
            showPlaceholderText = false
        case .noResult:
            showPlaceholderText = true
        case .searching:
            showPlaceholderText = true
        case .showingResults:
            showPlaceholderText = false
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
        
        let footerView = UIView()
        tableView.tableFooterView = footerView
    }
}

//MARK: - UISearchResultsUpdating
extension CitySearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            timer.invalidate()
            
            if searchText.count > 1 {
                if filteredLocations.isEmpty {
                    searchState = .searching
                }
                
                timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(searchForCities(sender:)), userInfo: searchText, repeats: false)
            } else {
                filteredLocations.removeAll()
                searchState = .empty
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
        if showPlaceholderText {
            return 1
        } else {
            return filteredLocations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        
        if showPlaceholderText {
            cell.textLabel?.text = searchState.rawValue
        } else {
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let location = filteredLocations[safe: indexPath.row] {
            delegate?.updateCitiesList(location: location)
        }
        
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
