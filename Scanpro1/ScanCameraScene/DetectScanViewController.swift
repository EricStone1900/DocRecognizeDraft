//
//  DetectScanViewController.swift
//  Scanpro1
//
//  Created by song on 2019/6/21.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class DetectScanViewController: UIViewController {
    ///视频相关
    let device: AVCaptureDevice? = {
        let device = AVCaptureDevice.default(for: .video)
        return device
    }()
    
    let session: AVCaptureSession = {
        let session = AVCaptureSession()
        return session
    }()
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    //相册相关
    var gallery: SHBGalleryController!
    
    //添加文档 true 新建文档 false
    var isAdd: Bool = false
    
    var parentFolderItem: DocFolderItem?
    var addFileItem: DocFileItem?
    
    init(superFolderItem: DocFolderItem?, fileItem: DocFileItem?) {
//        if superFolderItem != nil {
//            parentFolderItem = superFolderItem!
//        }else {
//            parentFolderItem = DocFolderItem()
//        }
        parentFolderItem = superFolderItem
        addFileItem = fileItem
        isAdd = (fileItem != nil ? true : false)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if setupVideoSettings() {
            startDetect()
        }
        setupToolMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    private func setupVideoSettings() -> Bool{
        guard let mydevice = self.device else {
            print("device unuseable")
            return false
        }
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: mydevice)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        //设置像素格式，否则CMSampleBufferRef转换NSImage的时候CGContextRef初始化会出问题
        //        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)]
        //https://www.jianshu.com/p/f280f2fa206c
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        if self.session.canAddInput(input!) {
            self.session.addInput(input!)
        }
        
        if self.session.canAddOutput(videoDataOutput) {
            self.session.addOutput(videoDataOutput)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
//        self.previewLayer.frame = CGRect(x: 0, y: 0, width:videoView.frame.width, height: videoView.frame.height)
        self.previewLayer.frame = CGRect(x: 0, y: 0, width:SCREEN_WIDTH, height: SCREEN_HEIGHT-89)
        self.previewLayer.videoGravity = .resizeAspectFill

//        self.previewLayer.borderWidth = 2
//        self.previewLayer.borderColor = UIColor.red.cgColor
        view.layer.addSublayer(previewLayer)
//        self.videoView.layer.addSublayer(previewLayer)
        return true
    }
    
    private func setupToolMenu() {
        let flashBtn = UIButton()
        flashBtn.setImage(UIImage(named: "FlashOn"), for: .normal)
        flashBtn.backgroundColor = .yellow
        view.addSubview(flashBtn)
        flashBtn.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.leading.equalTo(40)
            make.bottom.equalTo(view.snp.bottom).offset(-80)
        }
    }
    
    func startDetect() {
        self.session.startRunning()
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        gallery = SHBGalleryController()
        gallery.delegate = self
        
//        Gallery.Config.tabsToShow = [.imageTab]
//        present(gallery, animated: true, completion: nil)
         self.navigationController?.pushViewController(gallery, animated: true)
//        present(gallery, animated: true, completion: nil)
        
//        let navi = UINavigationController(rootViewController: gallery)
//        self.present(navi, animated: true, completion: nil)

    }
    func photoEditVC(images:[UIImage]) {
        if isAdd {
            guard addFileItem != nil else {
                return
            }
            //添加 page
//            print("添加 page")
//            var oldDocModels = addFileItem!.docPages.map({SHBDocumentModel(docPage: $0)})
//
//            let newdocModels = images.map({SHBDocumentModel(image: $0)})
//            var docModels = oldDocModels + newdocModels
            
            var newFileItem = addFileItem!
            let pageCount = addFileItem!.docPages.count
            let currentDate = Date()
            var newPages = [DocPageItem]()
            for (index, img) in images.enumerated() {
                var docPageModel = DocPageItem()
                let pageIndex = index + pageCount
                let folderNowPath = SHBFileTools.getNowFileFullPath(oldFullPath: newFileItem.folderpath!)
                let filepath = folderNowPath + "/" + "\(pageIndex)" + ".png"
                let fileOriPath = folderNowPath + "/" + "\(pageIndex)ori" + ".png"
                let scaleImg = img.scaled(toWidth: 375)
                let success = SHBFileManager.writeObjectToFile(filepath: filepath, content: scaleImg as AnyObject,overwrite: true)
                let csuccess = SHBFileManager.writeObjectToFile(filepath: fileOriPath, content: scaleImg as AnyObject,overwrite: true)
                
                if success && csuccess {
                    docPageModel.fileFullPath = filepath
                    docPageModel.folderpath = newFileItem.folderpath!
                    docPageModel.fileOriFullPath = fileOriPath
                    docPageModel.parentPath = newFileItem.parentPath
                    docPageModel.pageIndex = index + newFileItem.docPages.count
                    docPageModel.filesuffix = ".png"
                    docPageModel.timestampModifi = currentDate.unixTimestamp
                    newPages.append(docPageModel)
                }else {
                    print("error")
                }

            }
            
            newFileItem.docPages += newPages
            updateDocItemFile(fileItem: newFileItem)
            
            NewNotifications.DocItemChangeNoti.post(())
            NewNotifications.DocumentChangeNoti.post(())
            self.navigationController?.dismiss(animated: true, completion: nil)

            
        }else {
            let docModels = images.map({SHBDocumentModel(image: $0)})
            let vc = SHBPageViewController(docModels: docModels, startIndex: 0, parentFolderItem: parentFolderItem, editItem: nil)
            self.navigationController?.pushViewController(vc,animated: true)
        }

    }
    
    
    private func updateDocItemFile(fileItem: DocFileItem) {
        var folderModel = SHBFileTools.unArchiveModel()
        var findIndex = -1
        
        //根目录 查找
        for (index, item) in folderModel!.docFiles.enumerated() {
            if fileItem == item {
                findIndex = index
                break
            }
        }
        if findIndex >= 0 {
            folderModel!.docFiles[findIndex] = fileItem
        }else {
            //二级目录 查找
            var folderIndex = -1
            for (index, folderItem) in folderModel!.docFolders.enumerated() {
                let fileParentNowPath = SHBFileTools.getNowFileFullPath(oldFullPath: fileItem.parentPath)
                let folderNowpath = SHBFileTools.getNowFileFullPath(oldFullPath: folderItem.folderPath!)
                if fileParentNowPath == folderNowpath {
                    folderIndex = index
                    break
                }
            }
            if folderIndex >= 0 {
                var destinFolder = folderModel!.docFolders[folderIndex]
                var fileIndex = -1
                for (secfileIndex, secfileitem) in destinFolder.docFiles.enumerated() {
                    if fileItem == secfileitem {
                        fileIndex = secfileIndex
                        break
                    }
                }
                
                if fileIndex >= 0 {
                    destinFolder.docFiles[fileIndex] = fileItem
                }
                folderModel!.docFolders[folderIndex] = destinFolder
                
            }
            
        }
        
        SHBFileTools.archiveModel(folderModel: folderModel!)
        
    }
    
//    private func dismissVC() {
//        self.navigationController
//    }
}

extension DetectScanViewController:AVCaptureVideoDataOutputSampleBufferDelegate {
    
}

extension DetectScanViewController: SHBGalleryControllerDelegate {
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
        controller.navigationController?.popViewController()
//        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
