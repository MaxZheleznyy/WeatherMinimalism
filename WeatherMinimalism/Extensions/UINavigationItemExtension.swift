//
//  UINavigationItemExtension.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 4/17/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

extension UINavigationItem {
    func toggleNavBarButtons(isEnabled: Bool) {
        for rightButton in self.rightBarButtonItems ?? [UIBarButtonItem()] {
            rightButton.isEnabled = isEnabled
        }
        
        for leftButton in self.leftBarButtonItems ?? [UIBarButtonItem()] {
            leftButton.isEnabled = isEnabled
        }
    }
}
