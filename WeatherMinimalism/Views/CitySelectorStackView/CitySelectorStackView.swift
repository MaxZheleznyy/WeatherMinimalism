//
//  CitySelectorStackView.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/12/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

protocol CitySelectorStackViewDelegate {
   func didTapOnView(at index: Int)
}

class CitySelectorStackView: UIStackView {
    
    var delegate: CitySelectorStackViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        configureTapGestures()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTapGestures() {
        arrangedSubviews.forEach { view in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func didTapOnView(gestureRecognizer: UIGestureRecognizer) {
        guard let gestureView = gestureRecognizer.view else { return }
        
        if let index = arrangedSubviews.firstIndex(of: gestureView) {
            delegate?.didTapOnView(at: index)
       }
    }
}
