//
//  UINavigationItemExtensions.swift
//  Scanpro1
//
//  Created by song on 2019/6/16.
//  Copyright © 2019年 song. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension UINavigationItem {
    
    /// SwifterSwift: Replace title label with an image in navigation item.
    ///
    /// - Parameter image: UIImage to replace title with.
    func replaceTitle(with image: UIImage) {
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = image
        titleView = logoImageView
    }
    
}

#endif
