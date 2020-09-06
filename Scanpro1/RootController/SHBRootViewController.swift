//
//  SHBRootViewController.swift
//  Scanpro1
//
//  Created by song on 2019/6/15.
//  Copyright © 2019年 song. All rights reserved.
//

import UIKit

class SHBRootViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    func customNaviStyle() {
        self.navigationController?.navigationBar.setTitleFont(NAVIGATIONBAR_TITLE_FONT, color: NAVIGATIONBAR_TITLE_COLOR)
        self.navigationController?.navigationBar.setColors(background: NAVIGATIONBAR_RED_COLOR, text: NAVIGATIONBAR_TITLE_COLOR)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    

}
