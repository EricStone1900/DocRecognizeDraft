//
//  SettingMenuViewController.swift
//  Scanpro1
//
//  Created by song on 2019/6/21.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class SettingMenuViewController: UIViewController,SettingMenu {
    var dismissButton: UIButton?
    
    var titleLabel: UILabel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = NAVIGATIONBAR_RED_COLOR

        // Do any additional setup after loading the view.
        dismissButton = {
            let button = UIButton(frame: .zero)
            let oriImg = UIImage(named: "ic_menu")
            let scaledImg = oriImg?.scaled(toHeight: 28)
            button.setImage(scaledImg, for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = "Activity"
            label.font = UIFont.boldSystemFont(ofSize: 17)
//            label.textColor = UIColor.white
//            label.font = NAVIGATIONBAR_TITLE_FONT
            label.textColor = NAVIGATIONBAR_TITLE_COLOR
            label.sizeToFit()
            return label
        }()
    }
    
    @objc func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeMenu(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    

}

extension SettingMenuViewController: SettingMenuAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: SettingMenuTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    
    func animatorDidFinishDismissal(_ animator: SettingMenuTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: SettingMenuTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: SettingMenuTransitionAnimation) {
        print("willStartDismissal")
    }
}
