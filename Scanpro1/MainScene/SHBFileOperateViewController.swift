//
//  SHBFileOperateViewController.swift
//  Scanpro1
//
//  Created by song on 2019/7/15.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import ExpandingMenu
class SHBFileOperateViewController: SHBRootViewController {
    var theMenuButton: ExpandingMenuButton?
    
    var gallery: SHBGalleryController!
    
    var notiDispose = NewNotiDispose()
    
    var selectedMode: Bool = false
    
    let footView: SHBFileOperateFootView = {
        let btn1 = UIButton(type: .custom)
//        btn1.backgroundColor = .red
//        btn1.titleForNormal = "标签"
//        btn1.titleForDisabled = "标签禁止"
        let image1 = UIImage(named: "biaoqian")
        btn1.setImage(image1?.scaled(toWidth: 26), for: .normal)
        btn1.setTitle("标签", for: .normal)
        btn1.tag = 0
        
        let btn2 = UIButton(type: .custom)
//        btn2.backgroundColor = .red
//        btn2.titleForNormal = "合并"
//        btn2.titleForDisabled = "标签禁止"
        let image2 = UIImage(named: "merge")
        btn2.setImage(image2?.scaled(toWidth: 26), for: .normal)
        btn2.setTitle("合并", for: .normal)
        btn2.tag = 1
        
        let btn3 = UIButton(type: .custom)
//        btn3.backgroundColor = .red
//        btn3.titleForNormal = "分享"
//        btn3.titleForDisabled = "标签禁止"
        let image3 = UIImage(named: "share")
        btn3.setImage(image3?.scaled(toWidth: 26), for: .normal)
        btn3.setTitle("分享", for: .normal)
        btn3.tag = 2
        
        let btn4 = UIButton(type: .custom)
//        btn4.backgroundColor = .red
//        btn4.titleForNormal = "删除"
//        btn4.titleForDisabled = "标签禁止"
        let image4 = UIImage(named: "delete")
        btn4.setImage(image4?.scaled(toWidth: 26), for: .normal)
        btn4.setTitle("删除", for: .normal)
        btn4.tag = 3
        
        var btns = [UIButton]()
        btns.append(btn1)
        btns.append(btn2)
        btns.append(btn3)
        btns.append(btn4)
        let operateFootView = SHBFileOperateFootView(btnArr: btns)
        operateFootView.disableBtnsIndex = [Int](0...3)
        operateFootView.backgroundColor = NAVIGATIONBAR_RED_COLOR
        return operateFootView
    }()
    
    lazy var leftOneBarItem: UIBarButtonItem = {
        //左侧按钮
        let leftButImg = UIImage(named: "ic_menu")
        let leftbarButton = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(barButtonClicked(_:)), ImageNormal: (leftButImg?.scaled(toHeight: 28))!, ImageSel: (leftButImg?.scaled(toHeight: 28))!,tag: 1000)
        return leftbarButton
    }()
    
    lazy var rightOneBarItem: UIBarButtonItem = {
        //右侧按钮
        let button1Img = UIImage(named: "folder-add")
        let barButton1 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(barButtonClicked(_:)), ImageNormal: (button1Img?.scaled(toHeight: 28))!, ImageSel: (button1Img?.scaled(toHeight: 28))!,tag: 1001)
        barButton1.tag = 1001
        return barButton1
    }()
    
    lazy var rightTwoBarItem: UIBarButtonItem = {
        //右侧按钮
        let button2Img = UIImage(named: "folder-edit")
        let barButton2 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(barButtonClicked(_:)), ImageNormal: (button2Img?.scaled(toHeight: 28))!, ImageSel: (button2Img?.scaled(toHeight: 28))!,tag: 1002)
        barButton2.tag = 1002
        return barButton2
    }()
    
    lazy var barMarginBetweenItem: UIBarButtonItem = {
        //按钮间的空隙
        let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                  action: nil)
        return gap
    }()
    
    //选中单元格索引
    var selectedIndexs = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        customNaviStyle()
        configureExpandingMenuButton()
        footView.frame = CGRect(x: 0, y: view.frame.height, width: SCREEN_WIDTH, height: 100)
        footView.footDelegate = self
        view.addSubview(footView)
        
//        let btnnn = UIButton(type: .custom)
//        btnnn.backgroundColor = .red
//        btnnn.titleForNormal = "test1"
//        btnnn.addTarget(self, action: #selector(ootest), for: .touchUpInside)
//        btnnn.frame = CGRect(x: 80, y: 280, width: 80, height: 48)
//        view.addSubview(btnnn)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.bringSubview(toFront: footView)
    }
    
    //MARK: naviBaraction
    func setupNavi() {
        
    }
    
    @objc func barButtonClicked(_ button: UIButton) {
        print("bar按钮点击tag = \(button.tag)")
    }
    
    
    func configureExpandingMenuButton() {
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), image: UIImage(named: "chooser-button-tab")!, rotatedImage: UIImage(named: "chooser-button-tab-highlighted")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 132.0, y: self.view.bounds.height - 300.0)
        self.view.addSubview(menuButton)
        theMenuButton = menuButton
        
        ///custom
        // Bottom dim view
        menuButton.bottomViewColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        menuButton.bottomViewAlpha = 1
        
        
        
        func showAlert(_ title: String) {
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        func showDetectScene() {
            photoDetectVC(parentFolder: nil)
        }
        
        func showAlbumScene() {
            gallery = SHBGalleryController()
            gallery.delegate = self
            let navi = UINavigationController(rootViewController: gallery)
            self.present(navi, animated: true, completion: nil)
            
            //            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        func test() {
            let vc = SHBStackedViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        func testDetect() {
            let testImg = UIImage(named: "qxc_org")
            //            SHBDetectTool.shareInstance().getImgFramePoints(testImg!) { ([NSValue]) in
            //                print("\([NSValue])");
            //            }
            SHBDetectTool.shareInstance().getImgFramePoints(testImg!) { (data) in
                print("检测数据 = \(data)")
            }
        }
        
        func showiClould() {
            let vc = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf","public.image"], in: .open)
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        
        let image1 = UIImage(named: "icon_cloud_red")
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: "i-Clould", image: image1!.scaled(toWidth: 20)!, highlightedImage: image1!.scaled(toWidth: 20)!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
//            showAlert("i-Clould")
            showiClould()
        }
        
        let image2 = UIImage(named: "icon_detect_red")
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: "DetectAI", image: image2!.scaled(toWidth: 20)!, highlightedImage: image2!.scaled(toWidth: 20)!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            //            showAlert("Place")
            testDetect()
        }
        
        let image3 = UIImage(named: "icon_camera_red")
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: "Camera", image: image3!.scaled(toWidth: 20)!, highlightedImage: image3!.scaled(toWidth: 20)!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            
            showDetectScene()
        }
        
        let image4 = UIImage(named: "icon_share_red")
        let item4 = ExpandingMenuItem(size: menuButtonSize, title: "Test", image: image4!.scaled(toWidth: 20)!, highlightedImage: image4!.scaled(toWidth: 20)!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            //            showAlert("Thought")
            test()
        }
        
        let image5 = UIImage(named: "icon_photo_red")
        let item5 = ExpandingMenuItem(size: menuButtonSize, title: "Album", image: image5!.scaled(toWidth: 20)!, highlightedImage: image5!.scaled(toWidth: 20)!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            //            showAlert("Sleep")
            showAlbumScene()
        }
        
        menuButton.addMenuItems([item1, item2, item3, item4, item5])
        
        menuButton.willPresentMenuItems = { (menu) -> Void in
            print("MenuItems will present.")
        }
        
        menuButton.didDismissMenuItems = { (menu) -> Void in
            print("MenuItems dismissed.")
        }
    }
    
    func photoDetectVC(parentFolder: DocFolderItem?) {
        let detectVC = DetectScanViewController(superFolderItem: parentFolder, fileItem: nil)
        //            self.navigationController?.pushViewController(detectVC, animated: true)
        let navi = UINavigationController(rootViewController: detectVC)
        self.present(navi, animated: true, completion: nil)
    }
    func photoEditVC(images:[UIImage]) {
        let docModels = images.map({SHBDocumentModel(image: $0)})
//        let vc = SHBPageViewController(docModels: docModels, startIndex: 0, parentFolder: nil)
//        var docFolder = DocFolderItem()
//        docFolder.currentFolderIndex = 0
//        docFolder.folderPath =
        let vc = SHBPageViewController(docModels: docModels, startIndex: 0, parentFolderItem: nil, editItem: nil)
        gallery.navigationController?.pushViewController(vc,animated: true)
    }
    
    func setupFootView(isExpanded:Bool, animated:Bool, duration:TimeInterval = 0.25) {
        if isExpanded {
            UIView.animate(withDuration: duration) {
                self.footView.frame = CGRect(x: 0, y: self.view.frame.height - 100, width: SCREEN_WIDTH, height: 100)
            }
            
        }else {
            footView.disableBtnsIndex = [Int](0...3)
            UIView.animate(withDuration: duration) {
                self.footView.frame = CGRect(x: 0, y: self.view.frame.height, width: SCREEN_WIDTH, height: 100)
            }
        }
        
    }
    
    func updateFootView() {
        if selectedIndexs.count == 1 {
            footView.disableBtnsIndex = [1]
        }else if selectedIndexs.count > 1 {
            footView.disableBtnsIndex = []
        }else {
            footView.disableBtnsIndex = [Int](0...3)
        }
    }
    
    //MARK: 文件操作
    func operateBtnClicked(_ index: Int) {
        print("btn clickded \(index)")
        
    }
    
    func pickFileUrl(_ url: URL) {
        let urlStr = url.path
        let test = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        print("pickFileUrl \(url)")
        print("pickFileUrlStr \(urlStr)")
        print("pickFileUrlutf8 \(test)")
        
        let fileManager = FileManager.default
        let filePath = urlStr
        do {
            let attr = try fileManager.attributesOfItem(atPath: filePath)
            print("all attr = \(attr)")
        } catch {
            print("error:\(error)")
        }
        
    }
//    func signTag() {
//        print("signTag")
//    }
//
//    func fileMerge() {
//        print("fileMerge")
//    }
//
//    func fileShare() {
//        print("fileShare")
//    }
//
//    func fileDelete() {
//        print("fileDelete")
//    }

}

extension SHBFileOperateViewController: SHBGalleryControllerDelegate {
    func galleryController(_ controller: SHBGalleryController, didSelectImages images: [Image]) {
        print("didSelectImages")
        print("select items is \(images.count)")
    }
    
    func galleryController(_ controller: SHBGalleryController, requestLightbox images: [Image]) {
        print("requestLightbox")
        print("items count is \(images.count)")
        Image.resolve(images: images) { [weak self] resolvedImages in
            self?.photoEditVC(images: resolvedImages.compactMap({ $0 }))
        }
    }
    
    func galleryControllerDidCancel(_ controller: SHBGalleryController) {
        print("galleryControllerDidCancel")
        //        controller.navigationController?.popViewController()
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension SHBFileOperateViewController: SHBFileOperateFootViewDelegate {

    func SHBFileOperateFootViewBtn(btn: UIButton) {
        
        operateBtnClicked(btn.tag)
    }
    
}

extension SHBFileOperateViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("documentPickerWasCancelled")
    }
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        print("singgle url didPickDocumentAt \(url)")
        pickFileUrl(url)
    }
}
