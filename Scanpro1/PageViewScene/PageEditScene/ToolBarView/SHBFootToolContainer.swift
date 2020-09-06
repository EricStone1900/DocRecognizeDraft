//
//  SHBFootToolContainer.swift
//  Scanpro1
//
//  Created by song on 2019/7/22.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

protocol SHBFootToolContainerDelegate: class {
    func imageToolBtnClicked(btnIndex:Int)
    func brightToolValueChanged(value:Float)
    func transToolBtnClicked(btnIndex:Int)
}


class SHBFootToolContainer: UIView {
    
    weak var delegate: SHBFootToolContainerDelegate?
    
//    fileprivate var toolBtns: [UIButton]?
//    fileprivate var btnSelectedIndex: Int?
    
    var imageTool:SHBFileOperateFootView?
    
//    lazy var imageTool:SHBFileOperateFootView = { [unowned self] in
//        let button1 = UIButton(type: .custom)
//        let image1 = UIImage(named: "tupian")
//        button1.setImage(image1?.scaled(toWidth: 50), for: .normal)
////        button1.setTitle("原图", for: .normal)
////        button1.isSelected
////        if button1.isSelected {
////            button1.layer.borderColor = UIColor.green.cgColor
////
////        }else {
////            button1.layer.borderColor = UIColor.white.cgColor
////
////        }
//////        button1.layer.borderColor = UIColor.green.cgColor
////        button1.layer.borderWidth = 2
////        button1.layer.cornerRadius = 4
////        button1.layer.masksToBounds = true
//
//        button1.tag = 1000
//
//
//
//        let button2 = UIButton(type: .custom)
//        let image2 = UIImage(named: "tupian")
//        button2.setImage(image2?.scaled(toWidth: 50), for: .normal)
////        button2.setTitle("对比", for: .normal)
//        button2.tag = 1001
//
//
//        let button3 = UIButton(type: .custom)
//        let image3 = UIImage(named: "tupian")
//        button3.setImage(image3?.scaled(toWidth: 50), for: .normal)
////        button3.setTitle("黑白", for: .normal)
//        button3.tag = 1002
//
//
//        let button4 = UIButton(type: .custom)
//        let image4 = UIImage(named: "tupian")
//        button4.setImage(image4?.scaled(toWidth: 50), for: .normal)
////        button4.setTitle("灰度", for: .normal)
//        button4.tag = 1003
//
//        var btns = [UIButton]()
//        btns.append(button1)
//        btns.append(button2)
//        btns.append(button3)
//        btns.append(button4)
////        let colorTool = SHBFileOperateFootView(btnArr: btns, leadMargin: 60, btnWidth: 50, btnHeight: 50)
//        let colorTool = SHBFileOperateFootView(btnArr: btns, selecedIndex: 1)
//
//        colorTool.footDelegate = self
//        return colorTool
//    }()
    
//    fileprivate lazy var brightTool:UISlider = {
//        let sliderTool = UISlider()
//        sliderTool.addTarget(self, action: #selector(sliderValueChange(_:)), for: .valueChanged)
//        return sliderTool
//    }()
    
    fileprivate lazy var brightView:SHBCountView = {
        let sliderTool = SHBCountView(frame: .zero, initialValue: 10)
        sliderTool.backgroundColor = .white
        return sliderTool
    }()
    
    fileprivate lazy var transfromTool:SHBFileOperateFootView = {[unowned self] in
        let button1 = UIButton(type: .custom)
        let image1 = UIImage(named: "left-roate")
        button1.setImage(image1?.scaled(toWidth: 30), for: .normal)
//        button1.setTitle("左转", for: .normal)
        button1.tag = 1004
        
        
        
        let button2 = UIButton(type: .custom)
//        let image2 = UIImage(named: "right-roate")
//        button2.setImage(image2?.scaled(toWidth: 30), for: .normal)
        button2.setTitle("重置", for: .normal)
        button2.tag = 1005
        
        
        let button3 = UIButton(type: .custom)
        let image3 = UIImage(named: "right-roate")
        button3.setImage(image3?.scaled(toWidth: 30), for: .normal)
//        button3.setTitle("右转", for: .normal)
        button3.tag = 1006
        
        var btns = [UIButton]()
        btns.append(button1)
        btns.append(button2)
        btns.append(button3)
        let transTool = SHBFileOperateFootView(btnArr: btns, leadMargin: 40, btnWidth: 50, btnHeight: 50)
        transTool.footDelegate = self
        return transTool
    }()
    
    
    convenience init(btnArr:[UIButton],selecedIndex index: Int, showBottom bottom:Bool = false) {
        self.init()
//        toolBtns = btnArr
//        btnSelectedIndex = index
        imageTool = SHBFileOperateFootView(btnArr: btnArr, selecedIndex: index,showBottom: bottom)
        imageTool!.footDelegate = self
        setupTools()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemWidth = self.frame.width/3
        let itemHeight = self.frame.height
        imageTool!.frame = CGRect(x: 0, y: 0, width: itemWidth, height: itemHeight)
//        brightTool.frame = CGRect(x: itemWidth + (itemWidth - 200)*0.5, y: (itemHeight - 30)*0.5 , width: 200, height: 30)
        brightView.frame = CGRect(x: itemWidth+30, y: (itemHeight - 40)*0.5 , width: 90, height: 40)
        transfromTool.frame = CGRect(x: itemWidth*2, y: 0, width: itemWidth, height: itemHeight)
    }
    
    private func setupTools() {
        self.addSubview(imageTool!)
//        self.addSubview(brightTool)
        self.addSubview(brightView)
        self.addSubview(transfromTool)
    }
    
    @objc func sliderValueChange(_ sender: UISlider) {
        delegate?.brightToolValueChanged(value: sender.value)
    }

}

extension SHBFootToolContainer:SHBFileOperateFootViewDelegate {
//    func SHBFileOperateFootViewBtnClicekd(btnIndex:Int) {
//    }
    
    func SHBFileOperateFootViewBtn(btn:UIButton) {
        print("my btn tag = \(btn.tag)")
        if btn.tag <= 1003 {
            delegate?.imageToolBtnClicked(btnIndex: btn.tag)
        }else {
            delegate?.transToolBtnClicked(btnIndex: btn.tag)
        }
    }
}
