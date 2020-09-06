//
//  TextEidtCell.swift
//  Scanpro1
//
//  Created by song on 2019/8/20.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class TextEidtCell: UITableViewCell {
    static let identifier = "TextEidtCell"

    var docText: String? {
        didSet {
            if let text = docText {
                textField.text = text
            }
        }
    }
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
