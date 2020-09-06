//
//  MainViewController.swift
//  Scanpro1
//
//  Created by song on 2019/6/15.
//  Copyright © 2019年 song. All rights reserved.
//

import UIKit
protocol MainViewControllerDelegate: AnyObject {
    func leftBarButtonItemClicked()
}

class MainViewController: SHBRootViewController {
    weak var delegate : MainViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
        
        setupNavi()
    }

    override func customNaviStyle() {
        super.customNaviStyle()
        
    }
    
    private func setupNavi() {
        self.title = "ddasdsa"
        //右侧按钮
        let button1Img = UIImage(named: "avatar")
        let barButton1 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(tap1), ImageNormal: (button1Img?.scaled(toHeight: 20))!, ImageSel: (button1Img?.scaled(toHeight: 20))!)
        
        let button2Img = UIImage(named: "xingxing")
        let barButton2 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(tap1), ImageNormal: (button2Img?.scaled(toHeight: 30))!, ImageSel: (button2Img?.scaled(toHeight: 30))!)
        
        //按钮间的空隙
        let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                  action: nil)
        gap.width = 15
        
        //用于消除右边边空隙，要不然按钮顶不到最边上
        let spacerRight = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacerRight.width = -10
        
        self.navigationItem.rightBarButtonItems = [spacerRight,barButton2,gap,barButton1]
        
        //左侧按钮
        let leftButImg = UIImage(named: "qq")
        let newLeftImg = leftButImg?.tint(.red, blendMode: CGBlendMode.color)
        let leftbarButton = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(tap3), ImageNormal: (newLeftImg?.scaled(toHeight: 20))!, ImageSel: (newLeftImg?.scaled(toHeight: 20))!)
        
        //用于消除左边空隙，要不然按钮顶不到最前面
        let spacerLeft = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacerLeft.width = -10
        
        self.navigationItem.leftBarButtonItems = [spacerLeft, leftbarButton]
    }
    
    @objc func tap1() {
        print("设置按钮点击3")
    }
    
    @objc func tap2() {
        print("设置按钮点击")
    }
    
    @objc func tap3() {
        print("设置按钮点击")
        self.delegate?.leftBarButtonItemClicked()
    }

}
