//
//  SettingCell.swift
//  Scanpro1
//
//  Created by song on 2019/8/2.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    var itemData: SettingItem? {
        didSet {
            guard let item = itemData else {
                return
            }
            self.textLabel?.text = item.setttingType.nameText()
            self.imageView?.image = UIImage(named: item.imageName)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
