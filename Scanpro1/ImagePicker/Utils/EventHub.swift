//
//  EventHub.swift
//  SuperApp
//
//  Created by song on 2019/6/24.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation

class EventHub {
    
    typealias Action = () -> Void
    
    static let shared = EventHub()
    
    // MARK: Initialization
    
    init() {}
    
    var close: Action?
    var doneWithImages: Action?
    var doneWithVideos: Action?
    var stackViewTouched: Action?
}
