//
//  SHBCountView.swift
//  Scanpro1
//
//  Created by song on 2019/7/24.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class SHBCountView: UIView {
    let stepValue = 5
    let maxValue = 100
    let minValue = 0
    
    var currentValue: Int = 0
    
    fileprivate(set) var leftBtn:UIButton!
    fileprivate(set) var centerBtn:UIButton!
    fileprivate(set) var rightBtn:UIButton!
    
    init(frame: CGRect,initialValue:Int) {
        super.init(frame: frame)
        currentValue = initialValue
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let leftImage = UIImage.init(color: .blue, size: CGSize(width: 10,height: 10))
        let rightImage = UIImage.init(color: .yellow, size: CGSize(width: 10,height: 10))
        let centerimage = UIImage.init(color: .purple, size: CGSize(width: 20,height: 20))
        let btnLeft = UIButton(type: .custom)
        btnLeft.setBackgroundImage(leftImage, for: .normal)
        self.addSubview(btnLeft)
        leftBtn = btnLeft
        
        let btnRight = UIButton(type: .custom)
        btnRight.setBackgroundImage(rightImage, for: .normal)
        self.addSubview(btnRight)
        rightBtn = btnRight
        
        let btnCenter = UIButton(type: .custom)
        btnCenter.setBackgroundImage(centerimage, for: .normal)
        self.addSubview(btnCenter)
        centerBtn = btnCenter
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let centerBtnWidthHeight = self.frame.width*0.4
        let squareBtnWidth = self.frame.width*0.3
        let squareBtnHeight = self.frame.height*0.7
        
        leftBtn.frame = CGRect(x: 0, y: self.frame.height*0.3*0.5, width: squareBtnWidth, height: squareBtnHeight)
        centerBtn.frame = CGRect(x: self.frame.width*0.6*0.5, y: (self.frame.height - centerBtnWidthHeight)*0.5, width: centerBtnWidthHeight, height: centerBtnWidthHeight)
        rightBtn.frame = CGRect(x: self.frame.width - squareBtnWidth, y: self.frame.height*0.3*0.5, width: squareBtnWidth, height: squareBtnHeight)
        
    }

}
