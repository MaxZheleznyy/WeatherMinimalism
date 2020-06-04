//
//  UIImageViewExtension.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 4/17/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension WeatherIconImageView {
    func loadImageFromURL(url: String) {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.startAnimating()
        self.image = nil
        
        guard let URL = URL(string: url) else {
            print("Can't find an image for the url", url)
            self.activityIndicator.stopAnimating()
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.activityIndicator.stopAnimating()
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL) {
                if let image = UIImage(data: data) {
                    let imageTocache = image
                    imageCache.setObject(imageTocache, forKey: url as AnyObject)
                    
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                        self?.image = imageTocache
                    }
                }
            }
        }
    }
}
