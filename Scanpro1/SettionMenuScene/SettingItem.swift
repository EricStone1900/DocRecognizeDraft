//
//  SettingItem.swift
//  Scanpro1
//
//  Created by song on 2019/8/2.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
enum SettingType {
    case purchase
    case restore
    
    case camerasetting
    
    case support //give me 5
    case share  //shareapp
    case tutorial
    
    case about
    case privatepolicy
    
    func nameText() -> String {
        switch self {
        case .purchase:
            return "purchase"
        case .restore:
            return "restore"
        case .camerasetting:
            return "camerasettion"
        case .support:
            return "give me 5"
        case .share:
            return "shareapp"
        case .tutorial:
            return "tutorial"
        case .about:
            return "about"
        case .privatepolicy:
            return "privatepolicy"
//        default:
//            return "name"
        }
    }
}

struct SettingItem {
    var imageName: String
    var discribeName: String
    var setttingType: SettingType
    init(image:String,discribe:String,type:SettingType) {
        imageName = image
        discribeName = discribe
        setttingType = type
    }

}
