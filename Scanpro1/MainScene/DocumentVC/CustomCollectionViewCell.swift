//
//  CustomCollectionViewCell.swift
//  SuperApp
//
//  Created by song on 2019/6/19.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    let thumbnailView = ThumbnailView()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        return label
    }()
    
//    var items: [Item]? {
//        didSet {
//            if let items = items {
//                thumbnailView.images = items.map { $0.image! }
//                nameLabel.text = items.count == 1 ? items[0].name : "\(items.count) items"
//            } else {
//                thumbnailView.images = nil
//                nameLabel.text = nil
//            }
//        }
//    }
    var item: Any? {
        didSet {
            if let item = item as? DocFolderItem{
//                var images = [UIImage]()
//                for fileItem in item.docFiles {
//                    let pageitem = fileItem.docPages[0]
//                }
//                let image = item.folderImage!
//                thumbnailView.images = [image]
                thumbnailView.item = item
                nameLabel.text = item.folderName
            }else { //DocFileItem
//                let image = UIImage(named: "chooser-moment-icon-camera-highlighted")!
//                thumbnailView.images = [image]
                thumbnailView.item = item
                nameLabel.text = "DocFileItem"
            }
        }
    }
    
    var selectMode: Bool? {
        didSet {
            if let inSelectedMode = selectMode  {
                coverView.isHidden = !inSelectedMode
            }
        }
    }
    
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
    
    var beChoosen: Bool? {
        didSet {
            if let choosen = beChoosen  {
                if choosen {
                    iconChoose.image = UIImage(named: "file-selected-icon")
                }else {
                    iconChoose.image = UIImage(named: "file-unselected-icon")
                }
            }
        }
    }
    
    let iconChoose: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "icon_default")
        return iconView
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
        thumbnailView.widthAnchor.constraint(equalTo: thumbnailView.heightAnchor).isActive = true
        
        insertSubview(stackIndicatorView, belowSubview: thumbnailView)
        thumbnailView.centerXAnchor.constraint(equalTo: stackIndicatorView.centerXAnchor).isActive = true
        thumbnailView.centerYAnchor.constraint(equalTo: stackIndicatorView.centerYAnchor).isActive = true
        stackIndicatorWidthConstraint = thumbnailView.widthAnchor.constraint(equalTo: stackIndicatorView.widthAnchor)
        stackIndicatorWidthConstraint.isActive = true
        stackIndicatorHeightConstraint = thumbnailView.heightAnchor.constraint(equalTo: stackIndicatorView.heightAnchor)
        stackIndicatorHeightConstraint.isActive = true
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant: 8.0).isActive = true
        leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        
        addSubview(coverView)
        coverView.addSubview(iconChoose)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverView.snp.makeConstraints { (make) in
            make.edges.equalTo(thumbnailView)
        }
        iconChoose.snp.makeConstraints { (make) in
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.top.equalTo(coverView.snp.top).offset(10)
            make.trailing.equalTo(coverView.snp.trailing).offset(-10)
        }
    }
}
