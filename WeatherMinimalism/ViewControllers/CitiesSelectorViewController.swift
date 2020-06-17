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
    let mainContentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentMainStackView: CitySelectorStackView = {
        let stackView = CitySelectorStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    //MARK: - Contants
    let viewModel = WeatherViewModel()
    
    weak var delegate: CitiesSelectorViewControllerDelegate?
    
    private var needToUpdate: Bool = false
    
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        contentMainStackView.delegate = self
        
        configureMainView()
        fillUpStackViewWithData()
    }
    
    func configureMainView() {
        view.addSubview(mainContentScrollView)
        mainContentScrollView.delegate = self
        
        mainContentScrollView.addSubview(contentMainStackView)
        
        let mainConstraints = [
            mainContentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainContentScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainContentScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainContentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentMainStackView.topAnchor.constraint(equalTo: mainContentScrollView.topAnchor, constant: 10),
            contentMainStackView.leadingAnchor.constraint(equalTo: mainContentScrollView.leadingAnchor, constant: 0),
            contentMainStackView.trailingAnchor.constraint(equalTo: mainContentScrollView.trailingAnchor, constant: 0),
            contentMainStackView.bottomAnchor.constraint(equalTo: mainContentScrollView.bottomAnchor, constant: 0),
            contentMainStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(mainConstraints)
    }
    
    func fillUpStackViewWithData() {
        for city in viewModel.publicSavedCities {
            let cityCellView = SelectCityCellView()
            
            cityCellView.currentCityNameLabel.text = city.name
            
            //TODO make a network call if there is no weather data
            let cityTemperature = city.currentWeather?.temperature ?? 0
            cityCellView.currentCityTemperatureLabel.text = String(format: "%.0f", cityTemperature) + "°"
            
            contentMainStackView.addArrangedSubview(cityCellView)
        }
        
        contentMainStackView.configureTapGestures()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            delegate?.citiesSelectorGoingToClose(needToUpdate: needToUpdate)
        }
    }
}

extension CitiesSelectorViewController: CitySelectorStackViewDelegate {
    func didTapOnView(at index: Int) {
        if let city = viewModel.publicSavedCities[safe: index] {
            print(city.name)
        }
    }
}
