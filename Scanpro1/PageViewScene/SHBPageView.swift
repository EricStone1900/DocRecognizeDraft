//
//  SHBPageView.swift
//  SuperApp
//
//  Created by song on 2019/6/26.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

protocol SHBPageViewDelegate: class {
    
    func pageViewDidTouch(_ pageView: SHBPageView)
}

class SHBPageView: UIView {
    var docModel: SHBDocumentModel
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    var contentFrame = CGRect.zero
    
    weak var pageViewDelegate: SHBPageViewDelegate?
    init(docModel: SHBDocumentModel) {
        self.docModel = docModel
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure() {
        imageView.image = docModel.image
//        self.backgroundColor = .blue
        addSubview(imageView)

    }
    
    func configureImageView() {
        guard let image = imageView.image else {
            centerImageView()
            return
        }

        let imageViewSize = imageView.frame.size
        let imageSize = image.size
        let realImageViewSize: CGSize

        if imageSize.width / imageSize.height > imageViewSize.width / imageViewSize.height {
            realImageViewSize = CGSize(
                width: imageViewSize.width,
                height: imageViewSize.width / imageSize.width * imageSize.height)
        } else {
            realImageViewSize = CGSize(
                width: imageViewSize.height / imageSize.height * imageSize.width,
                height: imageViewSize.height)
        }

        imageView.frame = CGRect(origin: CGPoint.zero, size: realImageViewSize)

        centerImageView()
    }
    
    func centerImageView() {
        let boundsSize = contentFrame.size
        var imageViewFrame = imageView.frame

        if imageViewFrame.size.width < boundsSize.width {
            imageViewFrame.origin.x = (boundsSize.width - imageViewFrame.size.width) / 2.0
        } else {
            imageViewFrame.origin.x = 0.0
        }

        if imageViewFrame.size.height < boundsSize.height {
            imageViewFrame.origin.y = (boundsSize.height - imageViewFrame.size.height) / 2.0
        } else {
            imageViewFrame.origin.y = 0.0
        }

        imageView.frame = imageViewFrame
    }
}

extension SHBPageView: LayoutConfigurable {
    @objc func configureLayout() {
        contentFrame = frame
//        contentSize = frame.size
        imageView.frame = frame
        
        configureImageView()
    }
}

