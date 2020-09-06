//
//  SHBDocumentImage.swift
//  SuperApp
//
//  Created by song on 2019/6/26.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class SHBDocumentModel {
    fileprivate(set) var image: UIImage?
    var docPageModel: DocPageItem?
    
    init(image:UIImage) {
        self.image = image
    }
    init(docPage: DocPageItem) {
        self.docPageModel = docPage
        let nowPath = SHBFileTools.getNowFileFullPath(oldFullPath: docPage.fileFullPath!)
        self.image = UIImage(contentsOfFile: nowPath)
    }
}

