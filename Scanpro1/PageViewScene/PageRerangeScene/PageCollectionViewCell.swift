//
//  PageCollectionViewCell.swift
//  Scanpro1
//
//  Created by song on 2019/8/7.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    static let identifier = "PageCollectionViewCell"
    
    var item: DocPageItem? {
        didSet {
            if let pageItem = item {
                let imageUrl = SHBFileTools.getNowFileFullPath(oldFullPath: pageItem.fileFullPath!)
                thumbnailView.imageView.image = UIImage(contentsOfFile: imageUrl)
                pageNum = pageItem.pageIndex + 1
            }
        }

    }
    
    var pageNum: Int? {
        didSet {
            if let num = pageNum {
                thumbnailView.pageNum = num
            }
        }
    }
    
    let thumbnailView = PageThumbnilView()
    
    let stackIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6.0
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.1)
        return view
    }()
    
    let coverView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6.0
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.1)
        return view
    }()
    
    var stackIndicatorWidthConstraint: NSLayoutConstraint!
    var stackIndicatorHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
    }
    
    private func initialize() {
        
        addSubview(thumbnailView)
        topAnchor.constraint(equalTo: thumbnailView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: thumbnailView.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: thumbnailView.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: thumbnailView.bottomAnchor).isActive = true
//        thumbnailView.widthAnchor.constraint(equalTo: thumbnailView.heightAnchor).isActive = true

        insertSubview(stackIndicatorView, belowSubview: thumbnailView)
        thumbnailView.centerXAnchor.constraint(equalTo: stackIndicatorView.centerXAnchor).isActive = true
        thumbnailView.centerYAnchor.constraint(equalTo: stackIndicatorView.centerYAnchor).isActive = true
        stackIndicatorWidthConstraint = thumbnailView.widthAnchor.constraint(equalTo: stackIndicatorView.widthAnchor)
        stackIndicatorWidthConstraint.isActive = true
        stackIndicatorHeightConstraint = thumbnailView.heightAnchor.constraint(equalTo: stackIndicatorView.heightAnchor)
        stackIndicatorHeightConstraint.isActive = true


        addSubview(coverView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        thumbnailView.snp.makeConstraints { (make) in
//            make.edges.equalTo(self)
//        }
        coverView.snp.makeConstraints { (make) in
            make.edges.equalTo(thumbnailView)
        }
    }
}
