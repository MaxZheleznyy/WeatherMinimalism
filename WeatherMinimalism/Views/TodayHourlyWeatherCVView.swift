//
//  TodayHourlyWeatherCVView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/2/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class TodayHourlyWeatherCVView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let bottomDividerView = self.addBottomDividerView()
        
        todayHourlyWeatherCollectionView.register(TodayHourlyWeatherCVCell.self, forCellWithReuseIdentifier: TodayHourlyWeatherCVCell.identifier)
        
        self.addSubview(todayHourlyWeatherCollectionView)
        
        let todayHourlyWeatherCollectionViewConstrainsts = [
            self.heightAnchor.constraint(equalToConstant: 110),
            
            todayHourlyWeatherCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            todayHourlyWeatherCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            todayHourlyWeatherCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            todayHourlyWeatherCollectionView.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(todayHourlyWeatherCollectionViewConstrainsts)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
