//
//  SpinnerViewController.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 4/17/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//
import UIKit

class SpinnerViewController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()

    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override func loadView() {
        view = UIView()
        
        let blurEffect = UIBlurEffect.init(style: .regular)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)

        self.view.addSubview(containerView)
        self.view.addSubview(spinner)

        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.startAnimating()
    }
}
