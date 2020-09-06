//
//  PageThumbnilView.swift
//  Scanpro1
//
//  Created by song on 2019/8/7.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class PageThumbnilView: UIView {
    // One image
    var imageView: UIImageView!
    
    var pageNum: Int? {
        didSet {
            if let num = pageNum {
                pageLabel.text = "\(num)"
            }
        }
    }
    
    var pageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.backgroundColor = .lightGray
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6.0
        
        func autoLayoutImageView() -> UIImageView {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = UIColor.white
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            return imageView
        }
        
        func pageNumLabel() -> UILabel {
            let pageView = UILabel()
            pageView.translatesAutoresizingMaskIntoConstraints = false
            pageView.backgroundColor = UIColor(white: 0, alpha: 0.4)
            pageView.textAlignment = .center
            pageView.clipsToBounds = true
            pageView.textColor = .white
            pageView.layer.cornerRadius = 3
            pageView.layer.masksToBounds = true
            return pageView
        }
        
        // One image
        
        imageView = autoLayoutImageView()
        pageLabel = pageNumLabel()
        addSubview(imageView)
        addSubview(pageLabel)
        
        topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        pageLabel.snp.makeConstraints { (make) in
            make.width.equalTo(18)
            make.height.equalTo(25)
            make.right.equalTo(imageView.snp.right).offset(-3)
            make.bottom.equalTo(imageView.snp.bottom).offset(-3)
        }
    }
}
