//
//  WeatherViewController.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 4/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let selectedLocation: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "...Location"
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
        return label
    }()
    
    let currentTime: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "28 March 2020"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 10, weight: .heavy)
        return label
    }()
    
    let tempLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°C"
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
        return label
    }()
    
    let tempDescription: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    let tempIcon: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(systemName: "cloud.fill")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .gray
        return img
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(selectedLocation)
        view.addSubview(tempLabel)
        view.addSubview(tempIcon)
        view.addSubview(tempDescription)
        view.addSubview(currentTime)
        view.addSubview(minTemp)
        view.addSubview(maxTemp)
        
        selectedLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        selectedLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        selectedLocation.heightAnchor.constraint(equalToConstant: 70).isActive = true
        selectedLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
        currentTime.topAnchor.constraint(equalTo: selectedLocation.bottomAnchor, constant: 4).isActive = true
        currentTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        currentTime.heightAnchor.constraint(equalToConstant: 10).isActive = true
        currentTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
        tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        tempLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        tempLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        tempIcon.topAnchor.constraint(equalTo: tempLabel.bottomAnchor).isActive = true
        tempIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        tempIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tempIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        tempDescription.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 12.5).isActive = true
        tempDescription.leadingAnchor.constraint(equalTo: tempIcon.trailingAnchor, constant: 8).isActive = true
        tempDescription.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tempDescription.widthAnchor.constraint(equalToConstant: 250).isActive = true

        minTemp.topAnchor.constraint(equalTo: tempIcon.bottomAnchor, constant: 80).isActive = true
        minTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        minTemp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        minTemp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        maxTemp.topAnchor.constraint(equalTo: minTemp.bottomAnchor).isActive = true
        maxTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        maxTemp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        maxTemp.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

