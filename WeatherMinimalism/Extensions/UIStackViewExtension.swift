//
//  UIStackViewExtension.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/17/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

extension UIStackView {
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }

    private func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        
        return view
    }
}
