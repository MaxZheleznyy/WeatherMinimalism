//
//  UIViewExtension.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 5/28/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

extension UIView {
    func addBottomDividerView() -> UIView {
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .separator
        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(bottomDividerView)
        
        let mainConstraints = [
            bottomDividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomDividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomDividerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomDividerView.heightAnchor.constraint(equalToConstant: 1),
            bottomDividerView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(mainConstraints)
        
        return bottomDividerView
    }
}
