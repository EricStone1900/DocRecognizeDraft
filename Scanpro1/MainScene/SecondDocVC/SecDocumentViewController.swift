//
//  SecDocumentViewController.swift
//  Scanpro1
//
//  Created by song on 2019/7/15.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import StackedCollectionView


class SecDocumentViewController: SHBFileOperateViewController {
    var fileItemModels = [DocFileItem]()
    var parentFolderItem: DocFolderItem
    
    let collectionView: UICollectionView = {
        let flowLayout = CustomFlowLayout()
        flowLayout.gestureEnable = true
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    init(parentFolder:DocFolderItem) {
        parentFolderItem = parentFolder
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupNavi()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.stackedDelegate = self
        collectionView.stackedDataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        topLayoutGuide.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: collectionView.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        
        
//        footView.frame = CGRect(x: 0, y: self.view.frame.height - 100, width: SCREEN_WIDTH, height: 100)
//        view.addSubview(footView)
        self.view.bringSubview(toFront: self.theMenuButton!)
//        sortData()
        setupDatas()
        addObserves()
    }
    
    override func setupNavi() {
        self.title = parentFolderItem.folderName
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
    
    //MARK: naviBaraction
    override func barButtonClicked(_ button: UIButton) {
        switch button.tag {
        case 1002:
            print("selectClicked")
            selectBtnClicked()
        default:
            print("default btntag = \(button.tag)")
        }
    }
    
    private func selectBtnClicked() {
        theMenuButton!.isHidden = !theMenuButton!.isHidden
        selectedMode = !selectedMode
        
        if let flowLayout = collectionView.collectionViewLayout as? CustomFlowLayout {
            flowLayout.gestureEnable = !selectedMode
        }
        selectedIndexs.removeAll()
        collectionView.reloadData()
        setupFootView(isExpanded: selectedMode, animated: true)
    }
    
    private func addObserves() {
        print("注册了通知")
        NewNotifications.DocumentChangeNoti.addObserve(notiDispose) { [weak self] in
            if let strongSelf = self {
                strongSelf.setupDatas()
            }
            print("详情页收到通知:", "随控制器消失而取消注册")
            
        }
    }
    
    private func setupDatas() {
        var docFolderModel = SHBFileTools.unArchiveModel()
        var index = -1
        for (folderIndex, folderItem) in docFolderModel!.docFolders.enumerated() {
            if folderItem == parentFolderItem {
                index = folderIndex
            }
        }
        if index >= 0 {
            fileItemModels = docFolderModel!.docFolders[index].docFiles
        }
        
        sortData()
//        SHBFileTools.archiveModel(folderModel: docFolderModel!)
        updateData()
    }
    
    private func sortData() {
        fileItemModels.sort(by: { $0.currentFolderIndex < $1.currentFolderIndex })
        collectionView.reloadData()
    }
    
    private func updateData() {
        var docFolderModel = SHBFileTools.unArchiveModel()
        
        var fileModels = [DocFileItem]()
        for (index, item) in fileItemModels.enumerated() {
            var itemModel = item
            itemModel.currentFolderIndex = index + 1
            fileModels.append(itemModel)
        }
        
        var index = -1
        for (folderIndex, folderItem) in docFolderModel!.docFolders.enumerated() {
            if folderItem == parentFolderItem {
                index = folderIndex
            }
        }
        if index >= 0 {
            docFolderModel!.docFolders[index].docFiles = fileModels
            parentFolderItem = docFolderModel!.docFolders[index]
        }
       
        SHBFileTools.archiveModel(folderModel: docFolderModel!)
        
    }
    
    private func allRefreshData() {
        
    }
    
    override func photoEditVC(images:[UIImage]) {
        print("photoEditVC imagescount = \(images.count)")
//        let currentDate = Date()
        let docModels = images.map({SHBDocumentModel(image: $0)})
//        let pagefolderName = "\(currentDate.unixTimestamp).page"
//        let newPageFolderpath = parentFolderItem.folderPath! + "/" + pagefolderName
//        //SHBFileTools.createFolderAtPath(path: parentFolderItem.folderPath!, folderName: pagefolderName)
//
//        var fileItemModel = DocFileItem()
//        fileItemModel.folderName = pagefolderName
//        fileItemModel.parentPath = parentFolderItem.folderPath!
//        fileItemModel.folderpath = newPageFolderpath
        let vc = SHBPageViewController(docModels: docModels, startIndex: 0, parentFolderItem: parentFolderItem, editItem: nil)
        gallery.navigationController?.pushViewController(vc,animated: true)
    }
    
    override func photoDetectVC(parentFolder: DocFolderItem?) {
        print("photoDetectVC ")
        let detectVC = DetectScanViewController(superFolderItem: parentFolderItem, fileItem: nil)
        let navi = UINavigationController(rootViewController: detectVC)
        self.present(navi, animated: true, completion: nil)
    }
    
    //MARK: 文件操作
    override func operateBtnClicked(_ index: Int) {
        switch index {
        case 0:
            print("biaoqian!!!")
        case 1:
            print("hebing!!!")
            mergeBtnClicked()
        case 2:
            print("fenxiang!!!")
            shareBtnClicked()
        case 3:
            print("shanchu!!!")
            deleteBtnClicked()
        default:
            print("nonononow btn index \(index)")
        }
    }
    
    private func mergeBtnClicked() {
        print("合并项的索引为：", selectedIndexs)
        var docFolderModel = SHBFileTools.unArchiveModel()
        guard docFolderModel != nil else {
            return
        }
        var files = [DocFileItem]()
        for itemIndex in selectedIndexs {
            let itemData = fileItemModels[itemIndex]
            files.append(itemData)
        }

        //需要移动的子文档中Page图片
        var pagesToMerge = [DocPageItem]()
        for fileItem in files {
            pagesToMerge += fileItem.docPages
        }


        //父文件夹
        var currentFolder = parentFolderItem
        let currentDate = Date()
        
        var docFile = DocFileItem()
        let pagefolderName = "\(currentDate.unixTimestamp).page"
        let currentFileCount = SHBFileTools.currentFileCount() + 1
        docFile.folderIndex = currentFileCount
        docFile.currentFolderIndex = 0
        SHBFileTools.updateFileCount(currentFileCount)
        let newDocfileFolder = SHBFileTools.createFolderAtPath(path: currentFolder.folderPath!, folderName: pagefolderName)
        docFile.folderpath = newDocfileFolder
        docFile.timestampModifi = currentDate.unixTimestamp
        docFile.folderName = "new merge\(currentDate.unixTimestamp)"
        

        //移动所有子文档到新建文件夹
        var updateSouceFiles = [DocPageItem]()
        for (index,pageModel) in pagesToMerge.enumerated() {
            var docPageModel = pageModel
            let sourceFilepath = docPageModel.fileFullPath!
            let destinFilepath = newDocfileFolder! + "/" + "\(index)" + ".png"
            let success = SHBFileManager.moveFileToPath(fromPath: sourceFilepath, toPath: destinFilepath)
            if success {
                docPageModel.fileFullPath = destinFilepath
                docPageModel.folderpath = docFile.folderpath!
                docPageModel.parentPath = docFile.folderpath!
                docPageModel.pageIndex = index
                docPageModel.filesuffix = ".png"
                docPageModel.timestampModifi = currentDate.unixTimestamp
                updateSouceFiles.append(docPageModel)
            }else {
                print("文件写入出错")
            }
        }
        docFile.docPages = updateSouceFiles
        currentFolder.docFiles = currentFolder.docFiles.filter {
            !files.contains($0)
        }
        currentFolder.docFiles.append(docFile)
        

        //删除需要移动的子文档

        docFolderModel!.docFolders = docFolderModel!.docFolders.filter {
            parentFolderItem != $0
        }
        
        docFolderModel!.docFolders.append(currentFolder)


        files.forEach {
            let currentfullPath = SHBFileTools.getNowFileFullPath(oldFullPath: $0.folderpath!)
            if SHBFileManager.deleteFileAtPath(path: currentfullPath) {
                print("删除成功")
            }else {
                print("删除失败")
            }
        }



        SHBFileTools.archiveModel(folderModel: docFolderModel!)
        selectedIndexs.removeAll()
        setupDatas()
        selectBtnClicked()
        
    }

    private func shareBtnClicked() {
        print("选择的索引为：", selectedIndexs)
        var files = [DocFileItem]()
        for itemIndex in selectedIndexs {
            let itemData = fileItemModels[itemIndex]
            files.append(itemData)
        }

        //需要移动的子文档中Page图片
        var pagesToShare = [DocPageItem]()
        for fileItem in files {
            pagesToShare += fileItem.docPages
        }


        let images = pagesToShare.map({UIImage(contentsOfFile: SHBFileTools.getNowFileFullPath(oldFullPath: $0.fileFullPath!))!})
        let vc = VisualActivityViewController(images: images)

        vc.previewImageSideLength = 160
        vc.delegate = self
        footView.disableBtnsIndex = [0,1,3]
        presentActionSheet(vc,from: footView)


    }

    private func deleteBtnClicked(){
        print("删除项的索引为：", selectedIndexs)
        var docFolderModel = SHBFileTools.unArchiveModel()
        guard docFolderModel != nil else {
            return
        }
        
        var files = [DocFileItem]()
        for itemIndex in selectedIndexs {
            let itemData = fileItemModels[itemIndex]
            files.append(itemData)
        }
        
        var currentFolder = parentFolderItem
        currentFolder.docFiles = currentFolder.docFiles.filter {
            !files.contains($0)
        }


        files.forEach {
            let currentfullPath = SHBFileTools.getNowFileFullPath(oldFullPath: $0.folderpath!)
            if SHBFileManager.deleteFileAtPath(path: currentfullPath) {
                print("删除成功")
            }else {
                print("删除失败")
            }
        }
        
        docFolderModel!.docFolders = docFolderModel!.docFolders.filter {
            parentFolderItem != $0
        }
        
        docFolderModel!.docFolders.append(currentFolder)



        SHBFileTools.archiveModel(folderModel: docFolderModel!)
        selectedIndexs.removeAll()
        setupDatas()
        selectBtnClicked()
    }

    private func presentActionSheet(_ vc: VisualActivityViewController, from view: UIView) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.popoverPresentationController?.sourceView = view
            vc.popoverPresentationController?.sourceRect = view.bounds
            vc.popoverPresentationController?.permittedArrowDirections = [.up, .down]
        }

        present(vc, animated: true, completion: nil)
    }

    
}

extension SecDocumentViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileItemModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        cell.item = fileItemModels[indexPath.item]
        cell.selectMode = selectedMode
        if selectedIndexs.contains(indexPath.item) {
            cell.beChoosen = true
        }else {
            cell.beChoosen = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = fileItemModels[sourceIndexPath.item]
        fileItemModels.remove(at: sourceIndexPath.item)
        fileItemModels.insert(item, at: destinationIndexPath.item)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt \(indexPath)")
        if selectedMode{
            if let index = selectedIndexs.index(of: indexPath.item){
                selectedIndexs.remove(at: index) //原来选中的取消选中
            }else{
                selectedIndexs.append(indexPath.item) //原来没选中的就选中
            }
            updateFootView()
            self.collectionView.reloadItems(at: [indexPath])
        }else {
//            var folderPath: String?
            let itemModel = fileItemModels[indexPath.item]
//            folderPath = itemModel.folderpath
            let docModels = itemModel.docPages.map({SHBDocumentModel(docPage: $0)})
            
            let vc = SHBPageViewController(docModels: docModels, startIndex: 0, parentFolderItem: parentFolderItem, editItem: itemModel)
            self.navigationController?.pushViewController(vc,animated: true)
            
        }
    }
    
}

extension SecDocumentViewController: StackedCollectionViewDelegate,StackedCollectionViewDataSource {
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
        updateData()
    }
}

extension SecDocumentViewController: VisualActivityDelegate {
    func VisualActivityViewControllerWillDismiss() {
        updateFootView()
    }
}
