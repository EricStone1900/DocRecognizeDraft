//
//  ScanMainViewController.swift
//  Scanpro1
//
//  Created by song on 2019/6/21.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import ExpandingMenu
import StackedCollectionView

class MainViewController: SHBFileOperateViewController {
    deinit {
        print("MainViewController页销毁")
    }

    
    private lazy var presentationAnimator = SettingMenuTransitionAnimation()
    let naviTitle = "Activity"
    
//    var gallery: SHBGalleryController!

    
    var items = [Any]()
    
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
        view.backgroundColor = .blue
        buidMainJsonData()
        setupNavi()
        setupData()
        view.backgroundColor = .white
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
//        configureExpandingMenuButton()
        self.view.bringSubview(toFront: self.theMenuButton!)
//        footView.frame = CGRect(x: 0, y: view.frame.height, width: SCREEN_WIDTH, height: 100)
//        view.addSubview(footView)
        addObserves()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedIndexs.removeAll()
        selectedMode = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
//    private func setupFootView(isExpanded:Bool, animated:Bool, duration:TimeInterval = 0.25) {
//        if isExpanded {
//            UIView.animate(withDuration: duration) {
//                self.footView.frame = CGRect(x: 0, y: self.view.frame.height - 100, width: SCREEN_WIDTH, height: 100)
//            }
//            
//        }else {
//
//            UIView.animate(withDuration: duration) {
//                self.footView.frame = CGRect(x: 0, y: self.view.frame.height, width: SCREEN_WIDTH, height: 100)
//            }
//        }
//    }
    
    private func buidMainJsonData() {
        let docFolderModel = SHBFileTools.unArchiveModel()
        if docFolderModel == nil {
            var docModel = DocFolderItem()
            docModel.folderIndex = 0
            docModel.folderName = "Root"
            docModel.folderPath = SHBFileTools.createRootFolder()
            docModel.docFiles = [DocFileItem]()
            docModel.docFolders = [DocFolderItem]()
            docModel.timestampCreate = Date().unixTimestamp
            if SHBFileTools.archiveModel(folderModel: docModel) {
                print("建档成功")
            }else {
                print("建档失败")
            }
            
        }else {
            print("已有存档")
        }

    }
    
    private func addObserves() {
        print("注册了通知")
        NewNotifications.DocumentChangeNoti.addObserve(notiDispose) { [weak self] in
            if let strongSelf = self {
                strongSelf.refreshData()
            }
            print("详情页收到通知:", "随控制器消失而取消注册")
            
        }
    }
    
    private func setupData() {
        var docFolderModel = SHBFileTools.unArchiveModel()
        if docFolderModel != nil {
            print("modelData is \(String(describing: docFolderModel))")
            docFolderModel!.docFiles.forEach { [weak self] (item) in
                self?.items.append(item)
            }
            docFolderModel!.docFolders.forEach { [weak self] (item) in
                self?.items.append(item)
            }
        }else {
            print("modelData is nil")
        }
        items.sort { (item1, item2) -> Bool in
            var firstIndex: Int?
            var secondIndex: Int?
            let firstItem =  item1 as? DocFileProtocol
            firstIndex = firstItem?.currentFolderIndex
            
            let secondeItem =  item2 as? DocFileProtocol
            secondIndex = secondeItem?.currentFolderIndex
            return firstIndex! < secondIndex!
        }
        

        var folders = [DocFolderItem]()
        var files = [DocFileItem]()
        for (index, item) in items.enumerated() {
            if var itemModel = item as? DocFolderItem {
                itemModel.currentFolderIndex = index + 1
                folders.append(itemModel)
            }else if var itemModel = item as? DocFileItem {
                itemModel.currentFolderIndex = index + 1
                files.append(itemModel)
            }
        }

        docFolderModel!.docFolders.removeAll()
        docFolderModel!.docFolders = folders
        docFolderModel!.docFiles.removeAll()
        docFolderModel!.docFiles = files
        
        
        SHBFileTools.archiveModel(folderModel: docFolderModel!)
        
        
        
        print("dsfds")


    }
    
    private func refreshData() {
        items.removeAll()
        setupData()
    
        collectionView.reloadData()
    }
    override func setupNavi() {
        if selectedMode {
            self.title = "selectMode"
            self.navigationItem.leftBarButtonItems = nil
            //右侧按钮
            let button1Img = UIImage(named: "folder-add")
            let barButton1 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: nil, ImageNormal: (button1Img?.scaled(toHeight: 28))!, ImageSel: (button1Img?.scaled(toHeight: 28))!)
            barButton1.isEnabled = false
            let button2Img = UIImage(named: "folder-edit")
            let barButton2 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(selectClicked), ImageNormal: (button2Img?.scaled(toHeight: 28))!, ImageSel: (button2Img?.scaled(toHeight: 28))!)
            
            //按钮间的空隙
            let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                      action: nil)
            gap.width = 15
            
            //用于消除右边边空隙，要不然按钮顶不到最边上
            let spacerRight = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                              action: nil)
            spacerRight.width = -10
            
            self.navigationItem.rightBarButtonItems = [spacerRight,barButton2,gap,barButton1]
            
        }else {
            self.title = naviTitle
            //右侧按钮
            let button1Img = UIImage(named: "folder-add")
            let barButton1 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(addNewFolder), ImageNormal: (button1Img?.scaled(toHeight: 28))!, ImageSel: (button1Img?.scaled(toHeight: 28))!)
            
            let button2Img = UIImage(named: "folder-edit")
            let barButton2 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(selectClicked), ImageNormal: (button2Img?.scaled(toHeight: 28))!, ImageSel: (button2Img?.scaled(toHeight: 28))!)
            
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
            let leftButImg = UIImage(named: "ic_menu")
            let leftbarButton = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(tap3(_:)), ImageNormal: (leftButImg?.scaled(toHeight: 28))!, ImageSel: (leftButImg?.scaled(toHeight: 28))!)
            
            //用于消除左边空隙，要不然按钮顶不到最前面
            let spacerLeft = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                             action: nil)
            spacerLeft.width = -10
            
            self.navigationItem.leftBarButtonItems = [spacerLeft, leftbarButton]
        }

    }
    
    @objc func addNewFolder() {
        print("设置按钮点击1")
        var docFolderModel = SHBFileTools.unArchiveModel()
        if docFolderModel != nil {
            let baseFoldername = "New-Folder+"
//            var newFoldername = Date().dateString(ofStyle: .medium)
            let rootPath = SHBFileTools.createRootFolder()!
            let newFoldername = SHBFileTools.getNewFolderName(baseNewName: baseFoldername, parentFolderPath: rootPath)
            print("modelData is \(String(describing: docFolderModel))")
            let newFolderPath = SHBFileTools.createFolderAtRoot(folderName: newFoldername)
            var newFolder = DocFolderItem()
            let currentFileNum = SHBFileTools.currentFileCount() + 1
            newFolder.folderIndex = currentFileNum
            newFolder.currentFolderIndex = 0
            SHBFileTools.updateFileCount(currentFileNum)
            newFolder.timestampCreate = Date().unixTimestamp
            newFolder.folderName = newNameStr(ori: newFoldername)//newFoldername
            newFolder.folderPath = newFolderPath
            newFolder.parentPath = rootPath
            docFolderModel?.docFolders.append(newFolder)
            let archiveSuccess = SHBFileTools.archiveModel(folderModel: docFolderModel!)
            if archiveSuccess {
                print("新建文件夹成功")

                refreshData()
            }else {
                print("新建文件夹失败")
            }
        }else {

            print("modelData is nil")
        }
        
    }
    
    private func newNameStr(ori:String) -> String?{
        let spaceIndex = ori.index(of: "+")!
        let lastStr = ori[ori.index(after: spaceIndex)...]
        let newStr = "新建文件夹 " + lastStr
        return newStr
    }
    
    @objc func selectClicked() {
        print("设置按钮点击2")
        theMenuButton!.isHidden = !theMenuButton!.isHidden
        selectedMode = !selectedMode
        setupNavi()

        if let flowLayout = collectionView.collectionViewLayout as? CustomFlowLayout {
            flowLayout.gestureEnable = !selectedMode
        }
        selectedIndexs.removeAll()
        collectionView.reloadData()
        setupFootView(isExpanded: selectedMode, animated: true)
    }
    
    @objc func tap3(_ button: UIButton) {
        print("设置按钮点击3")
        showMenuAction(button)
    }
    
    func showMenuAction(_ sender: UIButton) {
//        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        let menuViewController = SettingMenuViewController()
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        menuViewController.titleLabel?.text = naviTitle
        
        presentationAnimator.animationDelegate = menuViewController
        presentationAnimator.supportView = navigationController!.navigationBar
        presentationAnimator.presentButton = sender
        present(menuViewController, animated: true, completion: nil)
    }
    
    //MARK: 文件操作
    override func operateBtnClicked(_ index: Int) {
        switch index {
        case 0:
            print("biaoqian")
        case 1:
            print("hebing")
            mergeBtnClicked()
        case 2:
            print("fenxiang")
            shareBtnClicked()
        case 3:
            print("shanchu")
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
        var folders = [DocFolderItem]()
        var files = [DocFileItem]()
        for itemIndex in selectedIndexs {
            let itemData = items[itemIndex]
            if let theData = itemData as? DocFolderItem {
                folders.append(theData)
            }else if let theData = itemData as? DocFileItem {
                files.append(theData)
            }
        }
        
        //需要移动的子文档
        var filesToMerge = [DocFileItem]()
        for folderItem in folders {
            filesToMerge += folderItem.docFiles
        }
        filesToMerge += files
        

        
        //新建文件夹
        let rootPath = SHBFileTools.createRootFolder()!
        let newFoldername = "merge\(Date().unixTimestamp)"
        let newFolderPath = SHBFileTools.createFolderAtRoot(folderName: newFoldername)
        var newFolder = DocFolderItem()
        let currentFileNum = SHBFileTools.currentFileCount() + 1
        newFolder.folderIndex = currentFileNum
        newFolder.currentFolderIndex = 0
        SHBFileTools.updateFileCount(currentFileNum)
        newFolder.timestampCreate = Date().unixTimestamp
        newFolder.folderName = "合并\(Date().unixTimestamp)"
        newFolder.folderPath = newFolderPath
        newFolder.parentPath = rootPath
        
        //移动所有子文档到新建文件夹
        var updateSouceFiles = [DocFileItem]()
        for fileItem in filesToMerge {
            let sourceFolder = SHBFileTools.getNowFileFullPath(oldFullPath: fileItem.folderpath!)
            let sourceFolderName = sourceFolder.lastPathComponent
            let destinFolderpath = newFolderPath! + "/" + sourceFolderName
            let success = SHBFileManager.moveFileToPath(fromPath: sourceFolder, toPath: destinFolderpath)
            if !success {
                print("文件\(String(describing: fileItem.folderName)) 转移出现错误")
            }
            var destinFileItem = fileItem
            destinFileItem.folderpath = destinFolderpath
            let currentFolderIndex = SHBFileTools.currentFileCount() + 1
            destinFileItem.folderIndex = currentFolderIndex
            SHBFileTools.updateFileCount(currentFolderIndex)
            updateSouceFiles.append(destinFileItem)
            
        }
        newFolder.docFiles = updateSouceFiles
        
        //删除需要移动的子文档
        docFolderModel!.docFolders = docFolderModel!.docFolders.filter {
            !folders.contains($0)
        }
        docFolderModel!.docFiles = docFolderModel!.docFiles.filter {
            !files.contains($0)
        }
        
        folders.forEach {
            let currentfullPath = SHBFileTools.getNowFileFullPath(oldFullPath: $0.folderPath!)
            if SHBFileManager.deleteFileAtPath(path: currentfullPath) {
                
            }
        }
        
        files.forEach {
            let currentfullPath = SHBFileTools.getNowFileFullPath(oldFullPath: $0.folderpath!)
            if SHBFileManager.deleteFileAtPath(path: currentfullPath) {
                print("删除成功")
            }else {
                print("删除失败")
            }
        }
        
        docFolderModel?.docFolders.append(newFolder)
        
        
        SHBFileTools.archiveModel(folderModel: docFolderModel!)
        selectedIndexs.removeAll()
        refreshData()
        
        selectClicked()
        
    }
    
    private func shareBtnClicked() {
        print("选择的索引为：", selectedIndexs)
        var folders = [DocFolderItem]()
        var files = [DocFileItem]()
        for itemIndex in selectedIndexs {
            let itemData = items[itemIndex]
            if let theData = itemData as? DocFolderItem {
                folders.append(theData)
            }else if let theData = itemData as? DocFileItem {
                files.append(theData)
            }
        }
        
        var filesToShare = [DocFileItem]()
        for folderItem in folders {
            filesToShare += folderItem.docFiles
        }
        filesToShare += files
        
        var filePages = [DocPageItem]()
        for fileItem in filesToShare {
            filePages += fileItem.docPages
        }
        
        
        let images = filePages.map({UIImage(contentsOfFile: SHBFileTools.getNowFileFullPath(oldFullPath: $0.fileFullPath!))!})
        let vc = VisualActivityViewController(images: images)
        
//        let testImg = UIImage(named: "channel13")
//        let vc = VisualActivityViewController(image: testImg!)
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
        var folders = [DocFolderItem]()
        var files = [DocFileItem]()
        for itemIndex in selectedIndexs {
            let itemData = items[itemIndex]
            if let theData = itemData as? DocFolderItem {
                folders.append(theData)
            }else if let theData = itemData as? DocFileItem {
                files.append(theData)
            }
        }
        docFolderModel!.docFolders = docFolderModel!.docFolders.filter {
            !folders.contains($0)
        }
        docFolderModel!.docFiles = docFolderModel!.docFiles.filter {
            !files.contains($0)
        }
        
        folders.forEach {
            let currentfullPath = SHBFileTools.getNowFileFullPath(oldFullPath: $0.folderPath!)
            if SHBFileManager.deleteFileAtPath(path: currentfullPath) {
                
            }
        }
        
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
        refreshData()
        
        selectClicked()
        
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

extension MainViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}

extension MainViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        cell.item = items[indexPath.item]
        cell.selectMode = selectedMode
        if selectedIndexs.contains(indexPath.item) {
            cell.beChoosen = true
        }else {
            cell.beChoosen = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = items[sourceIndexPath.item]
        items.remove(at: sourceIndexPath.item)
        items.insert(item, at: destinationIndexPath.item)

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt \(indexPath)")
        if selectedMode {
            if let index = selectedIndexs.index(of: indexPath.item){
                selectedIndexs.remove(at: index) //原来选中的取消选中
            }else{
                selectedIndexs.append(indexPath.item) //原来没选中的就选中
            }
            updateFootView()
            self.collectionView.reloadItems(at: [indexPath])
        }else {
//            let itemModel = items[indexPath.item]

            if let itemModel = items[indexPath.item] as? DocFolderItem {
//                let fileItems = itemModel.docFiles
                let secVC = SecDocumentViewController(parentFolder: itemModel)
                self.navigationController?.pushViewController(secVC,animated: false)
            }else if let itemModel = items[indexPath.item] as? DocFileItem {
//                "/var/mobile/Containers/Data/Application/51F58794-FD21-4161-ACC0-50796875DE3B/Documents/Common/1563174716.390207.page"
//                var folderPath: String?
//                folderPath = itemModel.folderpath
                let docModels = itemModel.docPages.map({SHBDocumentModel(docPage: $0)})

                let vc = SHBPageViewController(docModels: docModels, startIndex: 0, parentFolderItem: nil, editItem: itemModel)
                self.navigationController?.pushViewController(vc,animated: true)
            }


        }
    }
    
}

extension MainViewController: StackedCollectionViewDelegate,StackedCollectionViewDataSource {
    func collectionViewGestureDidMoveOutsideTriggerRadius(_ collectionView: UICollectionView) {
        print("Gesture moved outside trigger radius")
    }
    
    func collectionView(_ collectionView: UICollectionView, animationControllerFor indexPath: IndexPath) -> UICollectionViewCellAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt sourceIndexPath: IndexPath, into stackDestinationIndexPath: IndexPath) -> Bool {

        let stackDestinItem = items[stackDestinationIndexPath.item]
        if (stackDestinItem is DocFileItem) {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, into stackDestinationIndexPath: IndexPath) {
        
        print("Add item at index \(sourceIndexPath.item) into index \(stackDestinationIndexPath.item).")
        if let souceItem = items[sourceIndexPath.item] as? DocFileItem {
            if let stackDestinItem = items[stackDestinationIndexPath.item] as? DocFolderItem {
                
                var docFolderModel = SHBFileTools.unArchiveModel()
                if docFolderModel != nil {
                    docFolderModel!.docFiles = docFolderModel!.docFiles.filter {
                        $0 != souceItem
                    }
                    let sourceFolder = SHBFileTools.getNowFileFullPath(oldFullPath: souceItem.folderpath!)
//                    let sourceURL = NSURL(string: sourceFolder)!
                    let sourceFolderName = sourceFolder.lastPathComponent//sourceURL.lastPathComponent
                    let destinFolder = SHBFileTools.getNowFileFullPath(oldFullPath: stackDestinItem.folderPath!)
                    let destinFolderpath = destinFolder + "/" + sourceFolderName
                    let success = SHBFileManager.moveFileToPath(fromPath: sourceFolder, toPath: destinFolderpath)
                    if success {
                        print("文件移动成功")
                        var destinFileItem = souceItem
                        destinFileItem.folderpath = destinFolderpath
                        let currentFolderIndex = SHBFileTools.currentFileCount() + 1
                        destinFileItem.folderIndex = currentFolderIndex
                        destinFileItem.timestampModifi = Date().unixTimestamp
                        destinFileItem.parentPath = destinFolder
                        SHBFileTools.updateFileCount(currentFolderIndex)
                        
                        var newFolderModel = stackDestinItem
//                        newFolderModel.folderName = "join new Item"
                        newFolderModel.docFiles.append(destinFileItem)
                        items[stackDestinationIndexPath.item] = newFolderModel
                        items.remove(at: sourceIndexPath.item)
                        
                        var destinIndex: Int = -1
                        for (index, folderItem) in docFolderModel!.docFolders.enumerated() {
                            if folderItem == stackDestinItem {
                                destinIndex = index
                            }
                        }
                        if destinIndex >= 0 {
                            docFolderModel!.docFolders.remove(at: destinIndex)
                            docFolderModel!.docFolders.insert(newFolderModel, at: destinIndex)
                        }
                        
                        SHBFileTools.archiveModel(folderModel: docFolderModel!)
                    }else {
                        print("文件移动失败")
                    }
                }else {
                    print("docFolderModel is nil")
                }
            }
            
        }else if let souceItem = items[sourceIndexPath.item] as? DocFolderItem {
            if let stackDestinItem = items[stackDestinationIndexPath.item] as? DocFolderItem {
                
                var docFolderModel = SHBFileTools.unArchiveModel()
                if docFolderModel != nil {
                    docFolderModel!.docFolders = docFolderModel!.docFolders.filter {
                        $0 != souceItem
                    }
                    
                    //移动子文件
                    let destinFolder = SHBFileTools.getNowFileFullPath(oldFullPath: stackDestinItem.folderPath!)
                    var updateSouceFiles = [DocFileItem]()
                    for files in souceItem.docFiles {
                        let sourceFolder = SHBFileTools.getNowFileFullPath(oldFullPath: files.folderpath!)
                        let sourceFolderName = sourceFolder.lastPathComponent
                        let destinFolderpath = destinFolder + "/" + sourceFolderName
                        let success = SHBFileManager.moveFileToPath(fromPath: sourceFolder, toPath: destinFolderpath)
                        if !success {
                            print("文件\(String(describing: files.folderName)) 转移出现错误")
                        }
                        var destinFileItem = files
                        destinFileItem.folderpath = destinFolderpath
                        destinFileItem.parentPath = destinFolder
                        let currentFolderIndex = SHBFileTools.currentFileCount() + 1
                        destinFileItem.folderIndex = currentFolderIndex
                        SHBFileTools.updateFileCount(currentFolderIndex)
                        updateSouceFiles.append(destinFileItem)
                        
                    }
                    
                    var newFolderModel = stackDestinItem
//                    newFolderModel.folderName = "new join folder"
                    newFolderModel.docFiles = newFolderModel.docFiles + updateSouceFiles
                    newFolderModel.timestampModifi = Date().unixTimestamp
                    items[stackDestinationIndexPath.item] = newFolderModel
                    items.remove(at: sourceIndexPath.item)
                    
                    var destinIndex: Int = -1
                    for (index, folderItem) in docFolderModel!.docFolders.enumerated() {
                        if folderItem == stackDestinItem {
                            destinIndex = index
                        }
                    }
                    if destinIndex >= 0 {
                        docFolderModel!.docFolders.remove(at: destinIndex)
                        docFolderModel!.docFolders.insert(newFolderModel, at: destinIndex)
                    }
                    
                    let sourceFolder = SHBFileTools.getNowFileFullPath(oldFullPath: souceItem.folderPath!)
                    SHBFileManager.deleteFileAtPath(path: sourceFolder)
                    SHBFileTools.archiveModel(folderModel: docFolderModel!)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, finishMovingItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Move item from index \(sourceIndexPath.item) to index \(destinationIndexPath.item).")
        
        var docFolderModel = SHBFileTools.unArchiveModel()
        
        var folders = [DocFolderItem]()
        var files = [DocFileItem]()
        
        for (index, item) in items.enumerated() {
            if var itemModel = item as? DocFolderItem {
                itemModel.currentFolderIndex = index + 1
                folders.append(itemModel)
            }else if var itemModel = item as? DocFileItem {
                itemModel.currentFolderIndex = index + 1
                files.append(itemModel)
            }
        }
        
        
        docFolderModel!.docFolders.removeAll()
        docFolderModel!.docFolders = folders
        docFolderModel!.docFiles.removeAll()
        docFolderModel!.docFiles = files
        
        
        SHBFileTools.archiveModel(folderModel: docFolderModel!)
        
        
    }
}

extension MainViewController: VisualActivityDelegate {
    func VisualActivityViewControllerWillDismiss() {
        updateFootView()
    }
}

