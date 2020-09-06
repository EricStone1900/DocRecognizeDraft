//
//  PageRerangeViewController.swift
//  Scanpro1
//
//  Created by song on 2019/8/7.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

import StackedCollectionView
protocol PageRerangeViewControllerDelegate: class {
    func rerangeFileModel(filModel: DocFileItem)
}

class PageRerangeViewController: UIViewController {
    var fileItem: DocFileItem
    
    weak var delegate: PageRerangeViewControllerDelegate?
    
    var pageItems =  [DocPageItem]()
    
    init(fileModel: DocFileItem) {
        fileItem = fileModel
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var rightTwoBarItem: UIBarButtonItem = {
        //右侧按钮
        let button2Img = UIImage(named: "file-save")
        let barButton2 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(fileSave), ImageNormal: (button2Img?.scaled(toHeight: 28))!, ImageSel: (button2Img?.scaled(toHeight: 28))!,tag: 1002)
        barButton2.tag = 1002
        return barButton2
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let collectionView: UICollectionView = {
        let flowLayout = CustomFlowLayout()
        flowLayout.gestureEnable = true
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavi()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.stackedDelegate = self
        collectionView.stackedDataSource = self
        collectionView.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: PageCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        topLayoutGuide.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: collectionView.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        setupDatas()
    }
    
    private func setupNavi() {
        self.title = "重新排列"
        //右侧按钮
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
        self.navigationItem.rightBarButtonItems = [spacerRight,rightTwoBarItem,gap,placeBarbtnOne]
    }
    
    private func setupDatas() {
        pageItems = fileItem.docPages
    }
    
    @objc func fileSave() {
        print("保存按钮点击1")
        delegate?.rerangeFileModel(filModel: fileItem)
        updateDocItemFile(fileModel: fileItem)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popViewController()
        }

    }
    
    private func sortDatas() {
        var pages = [DocPageItem]()
        for (pageNumIndex,pageModel) in pageItems.enumerated() {
            var newPageModel = pageModel
            newPageModel.pageIndex = pageNumIndex
//            print("page index = \(pageNumIndex)")
            pages.append(newPageModel)
        }
        
//        pageItems.removeAll()
        pageItems = pages
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.collectionView.reloadData()
        }
        fileItem.docPages = pages
    }
    
//    private func refreshDatas() {
//        pageItems.removeAll()
//
//    }
    
    private func updateDocItemFile(fileModel: DocFileItem) {
        let fileItemModel = fileModel
//        var pages = [DocPageItem]()
//        for (pageNumIndex,pageModel) in fileItemModel.docPages.enumerated() {
//            var newPageModel = pageModel
//            newPageModel.pageIndex = pageNumIndex
//            pages.append(newPageModel)
//        }
//        fileItemModel.docPages = pages
        
        var folderModel = SHBFileTools.unArchiveModel()
        var findIndex = -1
        
        //根目录 查找
        for (index, item) in folderModel!.docFiles.enumerated() {
            if fileItemModel == item {
                findIndex = index
                break
            }
        }
        if findIndex >= 0 {
            folderModel!.docFiles[findIndex] = fileItemModel
        }else {
            //二级目录 查找
            var folderIndex = -1
            for (index, folderItem) in folderModel!.docFolders.enumerated() {
                let fileParentNowPath = SHBFileTools.getNowFileFullPath(oldFullPath: fileItemModel.parentPath)
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
                    if fileItemModel == secfileitem {
                        fileIndex = secfileIndex
                        break
                    }
                }
                
                if fileIndex >= 0 {
                    destinFolder.docFiles[fileIndex] = fileItemModel
                }
                folderModel!.docFolders[folderIndex] = destinFolder
                
            }
            
        }
        
        SHBFileTools.archiveModel(folderModel: folderModel!)
        NewNotifications.DocItemChangeNoti.post(())
        NewNotifications.DocumentChangeNoti.post(())
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.navigationController?.popViewController()
//        }
    }

    

}

extension PageRerangeViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.identifier, for: indexPath) as! PageCollectionViewCell
        cell.item = pageItems[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = pageItems[sourceIndexPath.item]
        pageItems.remove(at: sourceIndexPath.item)
        pageItems.insert(item, at: destinationIndexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt \(indexPath)")
    }
    
}

extension PageRerangeViewController: StackedCollectionViewDelegate,StackedCollectionViewDataSource {
    func collectionViewGestureDidMoveOutsideTriggerRadius(_ collectionView: UICollectionView) {
        print("Gesture moved outside trigger radius")
    }
    
    func collectionView(_ collectionView: UICollectionView, animationControllerFor indexPath: IndexPath) -> UICollectionViewCellAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt sourceIndexPath: IndexPath, into stackDestinationIndexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, into stackDestinationIndexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, finishMovingItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Move item from index \(sourceIndexPath.item) to index \(destinationIndexPath.item).")
        sortDatas()
    }
}
