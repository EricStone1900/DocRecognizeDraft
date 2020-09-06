//
//  SHBPageEditViewController.swift
//  Scanpro1
//
//  Created by song on 2019/7/3.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

protocol SHBPageEditViewControllerDeleagte: class {
    func updateImage(editImage: UIImage,oriImage: UIImage)
}

class SHBPageEditViewController: SHBRootViewController {
    var photoFrameEdit = false
    
    let footHeight = 100
    let operateHeight = 80
    
    var rotatedAngle:CGFloat = 0
    
    var cropImage: UIImage?
    
    var cropOriImage: UIImage?
    
    var editPageItem: DocPageItem?
    
    weak var delegate: SHBPageEditViewControllerDeleagte?
    
    fileprivate lazy var footView:SHBFileOperateFootView = { [unowned self] in
        let button1 = UIButton(type: .custom)
        let image1 = UIImage(named: "image-filter")
        button1.setImage(image1?.scaled(toWidth: 26), for: .normal)
        button1.setTitle("滤镜", for: .normal)
        button1.tag = 0
        
        let button2 = UIButton(type: .custom)
        let image2 = UIImage(named: "bright-hint2")
        button2.setImage(image2?.scaled(toWidth: 26), for: .normal)
        button2.setTitle("亮度", for: .normal)
        button2.tag = 1
        
        let button3 = UIButton(type: .custom)
        let image3 = UIImage(named: "roate")
        button3.setImage(image3?.scaled(toWidth: 26), for: .normal)
        button3.setTitle("旋转", for: .normal)
        button3.tag = 2
        
        let button4 = UIButton(type: .custom)
        let image4 = UIImage(named: "image-cut")
        button4.setImage(image4?.scaled(toWidth: 26), for: .normal)
        button4.setTitle("剪裁", for: .normal)
        button4.tag = 3
        
        var btns = [UIButton]()
        btns.append(button1)
        btns.append(button2)
        btns.append(button3)
        btns.append(button4)
        let foot = SHBFileOperateFootView(btnArr: btns, leadMargin: 40, btnWidth: 50, btnHeight: 50)
        foot.footDelegate = self
        foot.backgroundColor = NAVIGATIONBAR_RED_COLOR
        return foot
        }()

    fileprivate lazy var operatefootView:SHBFootToolContainer = {[unowned self] in
        
        let oriImage = adjustImg!
        let brightImage = SHBImageTool.covertContrastImage(oriImage)
        let blackWhiteImage = oriImage.lj_blackAndWhite()
        let grayImage = SHBImageTool.systemImage(toGrayImage: oriImage)
        
        let button1 = UIButton(type: .custom)
        let image1 = oriImage
        button1.setImage(image1.scaled(toWidth: 60), for: .normal)
        button1.setTitle("原图", for: .normal)
        button1.tag = 1000
        
        
        
        let button2 = UIButton(type: .custom)
        let image2 = blackWhiteImage
        button2.setImage(image2?.scaled(toWidth: 60), for: .normal)
        button2.setTitle("彩色", for: .normal)
        button2.tag = 1001
        
        
        let button3 = UIButton(type: .custom)
        let image3 = blackWhiteImage
        button3.setImage(image3?.scaled(toWidth: 60), for: .normal)
        button3.setTitle("黑白", for: .normal)
        button3.tag = 1002
        
        
        let button4 = UIButton(type: .custom)
        let image4 = grayImage
        button4.setImage(image4.scaled(toWidth: 60), for: .normal)
        button4.setTitle("灰度", for: .normal)
        button4.tag = 1003
        
        var btns = [UIButton]()
        btns.append(button1)
        btns.append(button2)
        btns.append(button3)
        btns.append(button4)

        let view = SHBFootToolContainer(btnArr: btns, selecedIndex: 1,showBottom: true)
        view.delegate = self
        view.backgroundColor = .yellow
        return view;
    }()
    
    
    fileprivate lazy var contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view;
    }()
    
    fileprivate var adjustImg: UIImage!
    fileprivate var changeImg: UIImage?
    
    fileprivate lazy var imageView:UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    fileprivate var initialRect: CGRect?
    fileprivate var finalRect: CGRect?
    fileprivate var cropRect: MMCropView?
    
    init(image:UIImage) {
        adjustImg = image
        super.init(nibName: nil, bundle: nil)
    }
    
    init(pageItem: DocPageItem) {
        editPageItem = pageItem
        let imagePath = SHBFileTools.getNowFileFullPath(oldFullPath: editPageItem!.fileFullPath!)
        let image = UIImage(contentsOfFile: imagePath)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavi()
        view.addSubview(self.footView)
        view.addSubview(self.contentView)
        imageView.image = adjustImg
        view.addSubview(self.imageView)
//        contentView.addSubview(imageView)
        
        view.addSubview(self.operatefootView)
        setupUIFrame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if photoFrameEdit {
//
//        }
    }
    
    private func setupCropEdit() {
        if photoFrameEdit {
//            if cropRect == nil {
//                let cropFrame = imageView.frame
//                cropRect = MMCropView(frame: cropFrame)
//                cropRect?.layer.borderColor = UIColor.purple.cgColor
//                cropRect?.layer.borderWidth = 2
//                view.addSubview(cropRect!)
//
//                let singlePan = UIPanGestureRecognizer(target: self, action: #selector(singlePan(_:)))
//                singlePan.maximumNumberOfTouches = 1;
//                cropRect?.addGestureRecognizer(singlePan)
//
//                view.bringSubview(toFront: cropRect!)
//            }
            if cropRect != nil {
                cropRect?.removeFromSuperview()
                cropRect = nil
            }
            let cropFrame = imageView.frame
            cropRect = MMCropView(frame: cropFrame)
            cropRect?.layer.borderColor = UIColor.purple.cgColor
            cropRect?.layer.borderWidth = 2
            view.addSubview(cropRect!)
            
            let singlePan = UIPanGestureRecognizer(target: self, action: #selector(singlePan(_:)))
            singlePan.maximumNumberOfTouches = 1;
            cropRect?.addGestureRecognizer(singlePan)
            
            view.bringSubview(toFront: cropRect!)
            
            cropRect?.isHidden = false
            detectEdges()
//            initEdges()
            initialRect = imageView.frame
            finalRect = imageView.frame
        }else {
            cropRect?.isHidden = true
        }

    }
    
    private func setupUIFrame() {
        self.footView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - CGFloat(footHeight) - 64, width: SCREEN_WIDTH, height: CGFloat(footHeight))
        self.contentView.frame = CGRect(x: 15, y: 15, width: SCREEN_WIDTH - 30, height: SCREEN_HEIGHT - CGFloat(footHeight + operateHeight) - 15*2 - 64)
        self.configureImageView(inputImage: self.adjustImg)
        
        self.operatefootView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - CGFloat(footHeight+operateHeight) - 64, width: SCREEN_WIDTH*3, height: CGFloat(operateHeight))
    }
    
//    override func viewWillLayoutSubviews() {
////        super.viewWillLayoutSubviews()
////        self.footView.frame = CGRect(x: 0, y: self.view.frame.height - 100, width: self.view.frame.width, height: 100)
////        self.contentView.frame = CGRect(x: 15, y: 80, width: self.view.frame.width - 30, height: self.view.frame.height - 100 - 30 - 15 - 40)
//        self.configureImageView()
////
////        self.testfootView.frame = CGRect(x: 0, y: 120, width: SCREEN_WIDTH*3, height: 100)
//    }
    
    private func photoFrameChange() {
        if photoFrameEdit {
            UIView.animate(withDuration: 0.3) { [unowned self] in
//                self.footView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - CGFloat(self.footHeight), width: SCREEN_WIDTH, height: CGFloat(self.footHeight))
                self.contentView.frame = CGRect(x: 15, y: 15, width: SCREEN_WIDTH - 30, height: SCREEN_HEIGHT - CGFloat(self.footHeight) - 64 - 15*2)
                self.configureImageView(inputImage: self.changeImg ?? self.adjustImg)
                
                self.operatefootView.alpha = 0
            }
            
            
        }else {
            UIView.animate(withDuration: 0.3) { [unowned self] in
//                self.footView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - CGFloat(self.footHeight), width: SCREEN_WIDTH, height: CGFloat(self.footHeight))
                self.contentView.frame = CGRect(x: 15, y: 15, width: SCREEN_WIDTH - 30, height: SCREEN_HEIGHT - CGFloat(self.footHeight + self.operateHeight) - 64 - 15*2)
                self.configureImageView(inputImage: self.changeImg ?? self.adjustImg)
            
                self.operatefootView.alpha = 1
            }
        }
    }
    
    //cropView
    private func configureImageView(inputImage:UIImage?) {
        guard let image = inputImage else {
            centerImageView()
            return
        }
        
        let imageViewSize = contentView.frame.size
        let imageSize = image.size
        let realImageViewSize: CGSize
        
        if imageSize.width / imageSize.height > imageViewSize.width / imageViewSize.height {
            realImageViewSize = CGSize(
                width: imageViewSize.width,
                height: imageViewSize.width / imageSize.width * imageSize.height)
        } else {
            realImageViewSize = CGSize(
                width: imageViewSize.height / imageSize.height * imageSize.width,
                height: imageViewSize.height)
        }
        
        imageView.frame = CGRect(origin: CGPoint.zero, size: realImageViewSize)
        
        centerImageView()
    }
    
    private func centerImageView() {
        let boundsSize = contentView.frame.size
        var imageViewFrame = imageView.frame
        
        if imageViewFrame.size.width < boundsSize.width {
            imageViewFrame.origin.x = (boundsSize.width - imageViewFrame.size.width) / 2.0
        } else {
            imageViewFrame.origin.x = contentView.frame.origin.x
        }
        
        if imageViewFrame.size.height < boundsSize.height {
            let yOffset = (boundsSize.height - imageViewFrame.size.height) / 2.0
            imageViewFrame.origin.y = contentView.frame.origin.y + yOffset
        } else {
            imageViewFrame.origin.y = contentView.frame.origin.y
        }
        
        imageView.frame = imageViewFrame
    }
    
    @objc func singlePan(_ gesture: UIPanGestureRecognizer) {
        print("singlePan")
        let posInStretch = gesture.location(in: cropRect!)
        switch gesture.state {
        case .began:
            cropRect?.findPointAtLocation(location: posInStretch)
        case .ended:
            cropRect?.activePoint?.backgroundColor = .gray
            cropRect?.activePoint = nil
            cropRect?.checkangle(index: 0)
        default:
            break
        }
        cropRect?.moveActivePointToLocation(locationPoint: posInStretch)
        
    }
    
    private func initEdges() {
        cropRect!.topLeftCornerToCGPoint(point: CGPoint(x: 0, y: 0 ))
        cropRect!.topRightCornerToCGPoint(point: CGPoint(x: 0 + imageView.frame.width, y: 0))
        cropRect!.bottomRightCornerToCGPoint(point: CGPoint(x: 0 + imageView.frame.width, y: 0 + imageView.frame.height))
        cropRect!.bottomLeftCornerToCGPoint(point: CGPoint(x: 0, y: 0 + imageView.frame.height))
    }
    
    private func detectEdges() {
        let image = imageView.image
        SHBDetectTool.shareInstance().getImgFramePoints(image!) { [weak self] (data) in
            print("检测数据 = \(data)")
            print("detect imageView.frame = \(self!.imageView.frame)")
            //[NSPoint: {11, 12}, NSPoint: {131, 14}, NSPoint: {131, 167}, NSPoint: {11, 187}]
            let points = data
            if (points.count != 4) {
                self?.initEdges()
            }else {
                //坐标转换
                let wScale = self!.imageView.frame.width/160.0
                let hScale = self!.imageView.frame.height/192.0
                
                let leftUpValue = points[0]
                let rightUpValue = points[1]
                let rightDownValue = points[2]
                let leftDownValue = points[3]
                
                self!.cropRect!.topLeftCornerToCGPoint(point: CGPoint(x: leftUpValue.cgPointValue.x*wScale, y: leftUpValue.cgPointValue.y*hScale))
                self!.cropRect!.topRightCornerToCGPoint(point: CGPoint(x: rightUpValue.cgPointValue.x*wScale, y: rightUpValue.cgPointValue.y*hScale))
                self!.cropRect!.bottomRightCornerToCGPoint(point: CGPoint(x: rightDownValue.cgPointValue.x*wScale, y: rightDownValue.cgPointValue.y*hScale))
                self!.cropRect!.bottomLeftCornerToCGPoint(point: CGPoint(x: leftDownValue.cgPointValue.x*wScale, y: leftDownValue.cgPointValue.y*hScale))
                
//                self?.cropImage = SHBDetectTool.shareInstance().getFrameImage(image!, pointArr: points)
                
            }
        }
//        cropRect!.topLeftCornerToCGPoint(point: CGPoint(x: 10 + 10, y: imageView.frame.origin.y + 10))
//        cropRect!.topRightCornerToCGPoint(point: CGPoint(x: imageView.frame.origin.x + 340, y: imageView.frame.origin.y + 10))
//        cropRect!.bottomRightCornerToCGPoint(point: CGPoint(x: imageView.frame.origin.x + 340, y: imageView.frame.origin.y + 300))
//        cropRect!.bottomLeftCornerToCGPoint(point: CGPoint(x: imageView.frame.origin.x + 10, y: imageView.frame.origin.y + 300))
    }
    
    private func cropAction() {
//        guard let scaleFactor = imageView.contentScale() else {
//            return
//        }
        let scaleFactor = 1
        //坐标转换
        let wScale = imageView.frame.width/160.0
        let hScale = imageView.frame.height/192.0
        
        let leftUpPoint = cropRect?.coordinatesForPoint(point: 4, scaleFactor: CGFloat(scaleFactor))
        let leftUpPointChange = CGPoint(x: leftUpPoint!.x/wScale, y: leftUpPoint!.y/hScale)
        let leftUpPointValue = NSValue.init(cgPoint: leftUpPointChange)
        
        let rightUpPoint = cropRect?.coordinatesForPoint(point: 3, scaleFactor: CGFloat(scaleFactor))
        let rightUpPointChange = CGPoint(x: rightUpPoint!.x/wScale, y: rightUpPoint!.y/hScale)
        let rightUpPointValue = NSValue.init(cgPoint: rightUpPointChange)
        
        let rightDownPoint = cropRect?.coordinatesForPoint(point: 2, scaleFactor: CGFloat(scaleFactor))
        let rightDownPointChange = CGPoint(x: rightDownPoint!.x/wScale, y: rightDownPoint!.y/hScale)
        let rightDownPointValue = NSValue.init(cgPoint: rightDownPointChange)
        
        let leftDownPoint = cropRect?.coordinatesForPoint(point: 1, scaleFactor: CGFloat(scaleFactor))
        let leftDownPointChange = CGPoint(x: leftDownPoint!.x/wScale, y: leftDownPoint!.y/hScale)
        let leftDownPointValue = NSValue.init(cgPoint: leftDownPointChange)
        var points = [NSValue]()
        points.append(leftUpPointValue)
        points.append(rightUpPointValue)
        points.append(rightDownPointValue)
        points.append(leftDownPointValue)
        
        let image = imageView.image
        let oriImage = adjustImg.rotated(by: rotatedAngle)
        cropImage = SHBDetectTool.shareInstance().getFrameImage(image!, pointArr: points)
        cropOriImage = SHBDetectTool.shareInstance().getFrameImage(oriImage!, pointArr: points)
    }
    
    
    private func setupNavi() {
        self.navigationController?.navigationBar.setTitleFont(NAVIGATIONBAR_TITLE_FONT, color: NAVIGATIONBAR_TITLE_COLOR)
        self.navigationController?.navigationBar.setColors(background: NAVIGATIONBAR_RED_COLOR, text: NAVIGATIONBAR_TITLE_COLOR)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let leftBarButton = UIBarButtonItem.creatBarButtonItemTitle(target: self, action: #selector(dismissVC), title: "取消", titleColorNomal: .white, titleColorSel: .black)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        //右侧按钮
        let button2Img = UIImage(named: "file-save")
        let barButtonRight = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(save), ImageNormal: (button2Img?.scaled(toHeight: 28))!, ImageSel: (button2Img?.scaled(toHeight: 28))!,tag: 1002)
        
        
        let placeBarbtnOne = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                             action: nil)
        placeBarbtnOne.width = 20
        
        //按钮间的空隙
        let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                  action: nil)
        gap.width = 15
        
        //用于消除右边边空隙，要不然按钮顶不到最边上
        let spacerRight = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                          action: nil)
        spacerRight.width = -10
        self.navigationItem.rightBarButtonItems = [spacerRight,barButtonRight,gap,placeBarbtnOne]

    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        if cropRect != nil {
            if cropRect!.frameEdited() {
                print("切图和规")
                cropAction()
                if let endImg = cropImage {
                    imageView.image = endImg
                }

            }else {
                print("切图不和规")
            }
            cropRect?.isHidden = true
        }
        
        let editImage = imageView.image!
        let oriImage = cropOriImage ?? adjustImg.rotated(by: rotatedAngle)!

        delegate?.updateImage(editImage: editImage, oriImage: oriImage)
        dismissVC()
    }
    
    private func toolOperateBtnClicked(btnIndex: Int) {
        switch btnIndex {
        case 1000://原图
            print("操作 原图")
            imageOriginal()
        case 1001://对比
            print("操作 对比")
            imageContrast()
        case 1002://黑白
            print("操作 黑白")
            imageBlackWhite()
        case 1003://灰度
            print("操作 灰度")
            imageGray()
        case 1004://左转
            print("操作 左转")
            rotateLeft()
        case 1005://重置
            print("操作 重置")
            rotateReset()
        case 1006://右转
            print("操作 右转")
            rotateRight()
        default:
            print("button clicked tag \(btnIndex)")
        }
    }
    
    //图片旋转
    private func rotateRight() {
        let newImage = imageView.image!.rotated(by: .pi/2)
        rotatedAngle += (.pi/2)
        imageView.image = newImage
//        adjustImg = newImage
        changeImg = newImage
//        let _ = adjustImg.rotated( by: .pi/2)
        self.configureImageView(inputImage: newImage)
        
    }
    
    private func rotateLeft() {
        let newImage = imageView.image!.rotated(by: .pi/(-2))
        rotatedAngle += .pi/(-2)
        imageView.image = newImage
//        adjustImg = newImage
        changeImg = newImage
//        let _ = adjustImg.rotated( by: .pi/(-2))
        self.configureImageView(inputImage: newImage)
    }
    
    private func rotateReset() {
        let newImage = imageView.image!.rotated(by: -rotatedAngle)
        rotatedAngle = 0
        imageView.image = newImage //adjustImg
        changeImg = newImage
//        let _ = adjustImg.rotated( by: -rotatedAngle)
        self.configureImageView(inputImage: newImage)
    }
    
    //图片色彩
    private func imageOriginal() {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
//            self.imageView.image = self.adjustImg!
//            self.changeImg = self.adjustImg
//            self.configureImageView(inputImage: self.adjustImg)
//        })
        imageView.image = adjustImg.rotated(by: rotatedAngle)
        let newImage = imageView.image
        changeImg = newImage
        self.configureImageView(inputImage: newImage)
        
//        operatefootView.imageTool.changeBtnIndex(btnIndex: 0, image: adjustImg, bottomText: "ss")
    }
    
    private func imageContrast() {
        let oriImage = adjustImg.rotated(by: rotatedAngle)
        let newImage = SHBImageTool.covertContrastImage(oriImage!)
        imageView.image = newImage
        changeImg = newImage
//        operatefootView.imageTool.changeBtnIndex(btnIndex: 1, image: newImage, bottomText: "ss")
    }
    
    private func imageBlackWhite() {
//        //黑白二值
//        let oriImage = adjustImg!
//        let newImage = SHBImageTool.convertBlackWhiteImage(oriImage)
//        imageView.image = newImage
//        changeImg = newImage
        
        //原生黑白
        let oriImage = adjustImg.rotated(by: rotatedAngle)
        let newImage = oriImage!.lj_blackAndWhite()
        imageView.image = newImage
        changeImg = newImage
    }
    
    private func imageGray() {//灰度
        let oriImage = adjustImg.rotated(by: rotatedAngle)//adjustImg!
        let newImage = SHBImageTool.systemImage(toGrayImage: oriImage!)//SHBImageTool.convertGrayImage(oriImage)
        imageView.image = newImage
        changeImg = newImage
    }
    
    private func operateBtnClicked(btnIndex: Int) {
        switch btnIndex {
        case 0:
            photoFrameEdit = false
//            imageOriginal()
        case 1:
            photoFrameEdit = false
        case 2:
            photoFrameEdit = false
        case 3:
            photoFrameEdit = true
        default:
            print("button clicked tag \(btnIndex)")
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [], animations: { [unowned self] in
            //CGRect(x: 0, y: 120, width: SCREEN_WIDTH*3, height: 100)
            self.operatefootView.frame = CGRect(x: CGFloat(-btnIndex)*SCREEN_WIDTH, y: SCREEN_HEIGHT - CGFloat(self.footHeight+self.operateHeight) - 64, width: SCREEN_WIDTH*3, height: CGFloat(self.operateHeight))
        }, completion: { [unowned self] finished in
            if finished {
                print("fininsed")
                self.photoFrameChange()
                self.setupCropEdit()
            }
        })
    }

}

extension SHBPageEditViewController: SHBFileOperateFootViewDelegate{
    
    func SHBFileOperateFootViewBtn(btn:UIButton) {
        operateBtnClicked(btnIndex: btn.tag)
    }
}

extension SHBPageEditViewController: SHBFootToolContainerDelegate {
    func imageToolBtnClicked(btnIndex:Int) {
        print("imagToolclicked \(btnIndex)")
        toolOperateBtnClicked(btnIndex: btnIndex)
    }
    func brightToolValueChanged(value:Float) {
        print("value is \(value)")
        var test: CGFloat = 0.2
        if value < 0.2 {
            test = CGFloat(value + 0.2)
        }else if value > 0.9{
            test = 0.9
        }
        print("test zhi = \(String(describing: test))")
        let oriImage = adjustImg!//changeImg == nil ? adjustImg! : changeImg
        let newImage = SHBImageTool.adjustBrighterImage(oriImage, brightValue: test)
        imageView.image = newImage
        changeImg = newImage
    }
    func transToolBtnClicked(btnIndex:Int) {
        print("transToolBtnClicked \(btnIndex)")
        toolOperateBtnClicked(btnIndex: btnIndex)
    }
}
