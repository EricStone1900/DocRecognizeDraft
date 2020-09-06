//
//  SHBFileOperateFootView.swift
//  Scanpro1
//
//  Created by song on 2019/7/17.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
protocol SHBFileOperateFootViewDelegate: class {
//    func SHBFileOperateFootViewBtnClicekd(btnIndex:Int)
    func SHBFileOperateFootViewBtn(btn:UIButton)
}

extension SHBFileOperateFootViewDelegate {
    func SHBFileOperateFootViewBtn(btn:UIButton) {
        print("button....")
    }
}

class SHBFileOperateFootView: UIView {
    fileprivate var btnWidth: CGFloat = 60.0
    fileprivate var btnHeight: CGFloat = 40.0
    fileprivate var btnLeadMargin: CGFloat = 40.0
    fileprivate var bottomTitle: Bool = false
    
    fileprivate var btnSelectedIndex: Int? {
        didSet {
            btnBordRadius = 6
            btnBordColor = UIColor.green
        }
    }
    fileprivate var btnBordRadius: CGFloat?
    fileprivate var btnBordColor: UIColor?
    
    weak var footDelegate: SHBFileOperateFootViewDelegate?
    
    fileprivate(set) var operateBtns:[UIButton]?
    convenience init(btnArr:[UIButton],selecedIndex index: Int, showBottom bottom: Bool = false) {
        self.init()
        operateBtns = btnArr
        setupBtns()
        btnLeadMargin = 50
        btnWidth = 60
        btnHeight = 60
        btnSelectedIndex = index
        bottomTitle = bottom
    }
    
    convenience init(btnArr:[UIButton], leadMargin margin:CGFloat = 40, btnWidth width:CGFloat = 60, btnHeight height: CGFloat = 40) {
        self.init()
        operateBtns = btnArr
        setupBtns()
        btnLeadMargin = margin
        btnWidth = width
        btnHeight = height
    }
    
    
    var disableBtnsIndex: [Int]? {
        didSet {
            if let btnIndex = disableBtnsIndex {
                guard let btns = operateBtns else {
                    return
                }
                for (index, btn) in btns.enumerated() {
                    if btnIndex.contains(index) {
                        btn.isEnabled = false
                    }else {
                        btn.isEnabled = true
                    }
                }
            }
        }
    }
    
//    var highlightBtnsIndex: [Int]? {
//        didSet {
//            if let btnIndex = disableBtnsIndex {
//                guard let btns = operateBtns else {
//                    return
//                }
//                for (index, btn) in btns.enumerated() {
//                    if btnIndex.contains(index) {
//                        btn.isSelected = true
//                    }else {
//                        btn.isSelected = false
//                    }
//
//                    if btn.isSelected {
//                        btn.layer.borderColor = UIColor.green.cgColor
//                    }else {
//                        btn.layer.borderColor = UIColor.white.cgColor
//                    }
//
//                    btn.layer.borderWidth = 2
//                    btn.layer.masksToBounds = true
//                }
//            }
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBtns() {
        guard let btns = operateBtns else {
            return
        }
        btns.forEach {
            $0.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            self.addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let btns = operateBtns else {
            return
        }
        if btns.count > 1 {
            let topMargin = (self.frame.height - CGFloat(btnHeight))*0.5
            let btnBetweenSpace = (self.frame.width - 2*btnLeadMargin - CGFloat(btns.count)*btnWidth)/(CGFloat(btns.count-1))
            for (index, btn) in btns.enumerated() {
                print("index = \(index),btn title = \(String(describing: btn.titleForNormal))")
                let btnX = btnLeadMargin + CGFloat(index)*(btnWidth + btnBetweenSpace)
                btn.frame = CGRect(x: btnX, y: topMargin, width: btnWidth, height: btnHeight)
                if btn.titleLabel?.text != nil && !bottomTitle {
                    btn.titleColorForNormal = .white
                    btn.titleColorForDisabled = UIColor(white: 1, alpha: 0.6)
                    btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                    btn.layoutButton(style: .Top, imageTitleSpace: 3)
                }
                
                if btn.titleLabel?.text != nil && bottomTitle {
                    let label = UILabel()
                    label.text = btn.titleLabel?.text
                    label.textColor = .white
                    label.textAlignment = .center
                    label.frame = CGRect(x: 0, y: btnHeight - 20, width: btnWidth, height: 20)
                    label.backgroundColor = UIColor(white: 0, alpha: 0.3)
                    btn.addSubview(label)
                }


//                btn.tag = index
            }
            
            if btnSelectedIndex != nil {
                buttonClicked(btns[btnSelectedIndex!])
            }
        }
    }
    
    @objc func buttonClicked(_ button:UIButton) {
//        footDelegate?.SHBFileOperateFootViewBtnClicekd(btnIndex: button.tag)
        guard let btns = operateBtns else {
            return
        }
        for btn in btns {
            if button == btn {
                btn.isSelected = true
            }else {
                btn.isSelected = false
            }
            
            if btnSelectedIndex != nil {
                if btn.isSelected {
                    btn.layer.borderColor = btnBordColor?.cgColor ?? UIColor.green.cgColor
                }else {
                    btn.layer.borderColor = UIColor.white.cgColor
                }
                
                btn.layer.borderWidth =  2
                btn.layer.cornerRadius = btnBordRadius ?? 10
                btn.layer.masksToBounds = true
            }
        }
        


        footDelegate?.SHBFileOperateFootViewBtn(btn: button)
    }
    
    func changeBtnIndex(btnIndex:Int,image:UIImage,bottomText:String) {
        guard let btns = operateBtns else {
            return
        }
        let btn = btns[btnIndex]
        btn.setImage(image, for: .normal)
    
    }
}
