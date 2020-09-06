//
//  SHBPageFootView.swift
//  SuperApp
//
//  Created by song on 2019/6/26.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
public let btnFrameWidth:Int = 80
public let btnFrameHeight:Int = 60
public let btnBetweenMargin:Int = 20

protocol SHBPageFootViewDelegate: class {
    func SHBPageFootViewBtnClicekd(btnIndex:Int)
}

class SHBPageFootView: UIView {
    var buttons = [UIButton]()
    
    weak var footViewDelegate: SHBPageFootViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frontMargin = (self.frame.width - CGFloat(buttons.count * btnFrameWidth) - CGFloat((buttons.count - 1) * btnBetweenMargin)) * 0.5
        let topMargin = (self.frame.height - CGFloat(btnFrameHeight))*0.5
        
        for (index, btn) in buttons.enumerated() {
            print("index = \(index),btn title = \(String(describing: btn.titleForNormal))")
            let btnX = frontMargin + CGFloat(index*(btnFrameWidth + btnBetweenMargin))
            btn.frame = CGRect(x: btnX, y: topMargin, width: CGFloat(btnFrameWidth), height: CGFloat(btnFrameHeight))
            btn.layoutButton(style: .Top, imageTitleSpace: 5)
            btn.tag = index
            btn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            self.addSubview(btn)
        }
    }
    
    func setupButtons() {
        let button1 = UIButton(type: .custom)
        let image1 = UIImage(named: "chooser-moment-icon-music")
        button1.setImage(image1?.scaled(toWidth: 30), for: .normal)
        button1.setTitle("music", for: .normal)
        
        let button2 = UIButton(type: .custom)
        let image2 = UIImage(named: "chooser-moment-icon-place")
        button2.setImage(image2?.scaled(toWidth: 30), for: .normal)
        button2.setTitle("music", for: .normal)

        let button3 = UIButton(type: .custom)
        let image3 = UIImage(named: "chooser-moment-icon-music")
        button3.setImage(image3?.scaled(toWidth: 30), for: .normal)
        button3.setTitle("music", for: .normal)

        let button4 = UIButton(type: .custom)
        let image4 = UIImage(named: "chooser-moment-icon-place")
        button4.setImage(image4?.scaled(toWidth: 30), for: .normal)
        button4.setTitle("music", for: .normal)

        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        buttons.append(button4)
    }
    
    @objc func buttonClicked(_ button:UIButton) {
        footViewDelegate?.SHBPageFootViewBtnClicekd(btnIndex: button.tag)
    }
    
}
