//
//  SHBPageViewController.swift
//  SuperApp
//
//  Created by song on 2019/6/26.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import PDFReader

protocol SHBPageViewControllerPageDelegate: class {
    
    func SHBPageViewController(_ controller: SHBPageViewController, didMoveToPage page: Int)
}

protocol SHBPageViewControllerDismissalDelegate: class {
    
    func SHBPageViewControllerWillDismiss(_ controller: SHBPageViewController)
}

protocol SHBPageViewControllerTouchDelegate: class {
    
    func SHBPageViewController(_ controller: SHBPageViewController, didTouch docModel: DocPageItem, at index: Int)
}

public let footViewHeight:CGFloat = 100.0

class SHBPageViewController: UIViewController {
    
    // MARK: - Internal views
    
    lazy var scrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.backgroundColor = .green
        return scrollView
        }()
    
//    fileprivate(set) lazy var footerView: SHBPageFootView = { [unowned self] in
//        let view = SHBPageFootView()
//        view.footViewDelegate = self
//        return view
//        }()
    fileprivate(set) lazy var footerView: SHBFileOperateFootView = { [unowned self] in
//        let btn1 = UIButton(type: .custom)
//        btn1.backgroundColor = .red
//        btn1.titleForNormal = "标签"
//        btn1.titleForDisabled = "标签禁止"
//        let btn2 = UIButton(type: .custom)
//        btn2.backgroundColor = .red
//        btn2.titleForNormal = "合并"
//        btn2.titleForDisabled = "标签禁止"
//        let btn3 = UIButton(type: .custom)
//        btn3.backgroundColor = .red
//        btn3.titleForNormal = "分享"
//        btn3.titleForDisabled = "标签禁止"
//        let btn4 = UIButton(type: .custom)
//        btn4.backgroundColor = .red
//        btn4.titleForNormal = "删除"
//        btn4.titleForDisabled = "标签禁止"
//        var btns = [UIButton]()
//        btns.append(btn1)
//        btns.append(btn2)
//        btns.append(btn3)
//        btns.append(btn4)
        let button1 = UIButton(type: .custom)
        let image1 = UIImage(named: "image-adjust")
        button1.setImage(image1?.scaled(toWidth: 26), for: .normal)
        button1.setTitle("编辑", for: .normal)
        button1.tag = 0
        
        
        
        let button2 = UIButton(type: .custom)
        let image2 = UIImage(named: "chooser-moment-icon-place")
        button2.setImage(image2?.scaled(toWidth: 26), for: .normal)
        button2.setTitle("识别", for: .normal)
        button2.tag = 1
        
        
        let button3 = UIButton(type: .custom)
        let image3 = UIImage(named: "share")
        button3.setImage(image3?.scaled(toWidth: 26), for: .normal)
        button3.setTitle("分享", for: .normal)
        button3.tag = 2
        
        
        let button4 = UIButton(type: .custom)
        let image4 = UIImage(named: "fille-add")
        button4.setImage(image4?.scaled(toWidth: 26), for: .normal)
        button4.setTitle("添加", for: .normal)
        button4.tag = 3
        
        let buttonRerange = UIButton(type: .custom)
        let imageRerange = UIImage(named: "re-arrange2")
        buttonRerange.setImage(imageRerange?.scaled(toWidth: 26), for: .normal)
        buttonRerange.setTitle("重排", for: .normal)
        buttonRerange.tag = 4
        
        let buttonDelete = UIButton(type: .custom)
        let imageDelete = UIImage(named: "delete")
        buttonDelete.setImage(imageDelete?.scaled(toWidth: 26), for: .normal)
        buttonDelete.setTitle("删除", for: .normal)
        buttonDelete.tag = 5
        
        var btns = [UIButton]()
        btns.append(button1)
        btns.append(button2)
        btns.append(button3)
        btns.append(button4)
        //btn edit
        if isEdit {
            btns.insert(buttonRerange, at: 1)
            btns.append(buttonDelete)
        }
        
        let view = SHBFileOperateFootView(btnArr: btns)
        view.footDelegate = self
        return view
        }()

    // MARK: - Properties
    fileprivate var numberOfPages: Int {
        return pageViews.count
    }
    
    fileprivate(set) var seen = false
    
    fileprivate var pageViews = [SHBPageView]()
    
    fileprivate lazy var pageCountView:UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    fileprivate(set) var currentPage = 0 {
        didSet {
            currentPage = min(numberOfPages - 1, max(0, currentPage))
            
            if currentPage == numberOfPages - 1 {
                seen = true
            }
            
//            reconfigurePagesForPreload()
            pageUpdate(currentNum: currentPage + 1, totalNum: numberOfPages)
            pageDelegate?.SHBPageViewController(self, didMoveToPage: currentPage)
            
//            if let image = pageViews[currentPage].imageView.image, dynamicBackground {
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.125) {
//                    self.loadDynamicBackground(image)
//                }
//            }
        }
    }
    
    var spacing: CGFloat = 20 {
        didSet {
            configureLayout(view.bounds.size)
        }
    }
    
    fileprivate var initialImages: [SHBDocumentModel]
    fileprivate let initialPage: Int
    var presented = false
    
    var docModels: [SHBDocumentModel] {
        get {
            return pageViews.map { $0.docModel }
        }
        set(value) {
            initialImages = value
            configurePages(value)
        }
    }
    
//    var parentFolderPath: String!
    
    fileprivate(set) var isEdit = false
    var parentFolderItem: DocFolderItem!
    var editFileItem: DocFileItem?
    
    var notiDispose = NewNotiDispose()
    
    weak var pageDelegate: SHBPageViewControllerPageDelegate?
    weak var dismissalDelegate: SHBPageViewControllerDismissalDelegate?
    weak var imageTouchDelegate: SHBPageViewControllerTouchDelegate?
    
    
//    init(docModels:[SHBDocumentModel] = [],startIndex index: Int = 0,isEdit edit: Bool = false) {
//        self.initialImages = docModels
//        self.initialPage = index
//        self.isEdit = edit
//        parentFolderPath = SHBFileTools.createRootFolder()!
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    init(docModels:[SHBDocumentModel] = [],startIndex index: Int = 0, parentFolder folderPath: String?,isEdit edit: Bool = false) {
//        self.initialImages = docModels
//        self.initialPage = index
//        self.isEdit = edit
//        if folderPath != nil {
//            parentFolderPath = folderPath
//        }else {
//            parentFolderPath = SHBFileTools.createRootFolder()!
//        }
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    init(docModels:[SHBDocumentModel] = [],startIndex index: Int = 0, parentFolderItem folderItem: DocFolderItem?, isEdit edit: Bool = false) {
//        self.initialImages = docModels
//        self.initialPage = index
//        self.isEdit = edit
////        parentFolderPath = folderItem.folderPath
//        if folderItem != nil {
//            parentFolderItem = folderItem
//        }else {
//            var docModel = DocFolderItem()
//            docModel.folderIndex = 0
//            docModel.folderName = "Root"
//            docModel.folderPath = SHBFileTools.createRootFolder()!
//            docModel.docFiles = [DocFileItem]()
//            docModel.docFolders = [DocFolderItem]()
//            docModel.timestampCreate = Date().unixTimestamp
//            parentFolderItem = docModel
//        }
//
//        super.init(nibName: nil, bundle: nil)
//    }
    
    init(docModels:[SHBDocumentModel] = [],startIndex index: Int = 0, parentFolderItem folderItem: DocFolderItem?, editItem: DocFileItem?) {
        self.initialImages = docModels
        self.initialPage = index
        self.editFileItem = editItem
        self.isEdit = (editItem != nil ? true : false)
        //        parentFolderPath = folderItem.folderPath
        if folderItem != nil {
            parentFolderItem = folderItem
        }else {
            var docModel = DocFolderItem()
            docModel.folderIndex = 0
            docModel.folderName = "Root"
            docModel.folderPath = SHBFileTools.createRootFolder()!
            docModel.docFiles = [DocFileItem]()
            docModel.docFolders = [DocFolderItem]()
            docModel.timestampCreate = Date().unixTimestamp
            parentFolderItem = docModel
        }
        super.init(nibName: nil, bundle: nil)
        self.buildTempDir(docModels: docModels)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildTempDir(docModels:[SHBDocumentModel]) {
//        let images = docModels.map{$0.image}
        for (index,item) in docModels.enumerated() {
            let image = item.image!.imageWithNewSize(size: CGSize(width: item.image!.size.width*0.5, height: item.image!.size.height*0.5))
            let tempPath = SHBFileTools.createTempFolderAtRoot()
            let imagePath = tempPath + "/" + "\(index).png"
            _ = SHBFileManager.writeObjectToFile(filepath: imagePath, content: image as AnyObject, overwrite: true)
        }
    }
    
    private func clearTempDir() {
        let tempPath = SHBFileTools.createTempFolderAtRoot()
        _ = SHBFileManager.deleteFileAtPath(path: tempPath)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        self.navigationController?.navigationBar.isTranslucent = false
        setupNavi()
        [scrollView, footerView, pageCountView].forEach { view.addSubview($0) }
        configurePages(initialImages)
        goTo(initialPage, animated: false)
        addObserves()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if !presented {
//            presented = true
//            configureLayout(view.bounds.size)
//        }
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !presented {
            presented = true
            configureLayout(view.bounds.size)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearTempDir()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        scrollView.frame = view.bounds
//        footerView.frame.size = CGSize(
//            width: view.bounds.width,
//            height: 100
//        )
//
//        footerView.frame.origin = CGPoint(
//            x: 0,
//            y: view.bounds.height - footerView.frame.height
//        )
//
//    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        

//        scrollView.frame = view.bounds
        footerView.frame.size = CGSize(
            width: view.bounds.width,
            height: footViewHeight
        )
        
        footerView.frame.origin = CGPoint(
            x: 0,
            y: view.bounds.height - footerView.frame.height
        )
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - footerView.frame.height)
        
        pageCountView.frame = CGRect(x: (view.frame.width - 40)*0.5, y: view.frame.height - footerView.frame.height - 20 - 10, width: 40, height: 20)
        
    }
    
    private func addObserves() {
        print("注册了通知")
        NewNotifications.DocItemChangeNoti.addObserve(notiDispose) { [weak self] in
            if let strongSelf = self {
                let oldPageCount = strongSelf.docModels.count
                if let nowFileItem = strongSelf.getUpdateDocModels() {
                    let docModels = nowFileItem.docPages.map({SHBDocumentModel(docPage: $0)})
                    strongSelf.docModels = docModels
                    if oldPageCount < docModels.count {
                        strongSelf.goTo(oldPageCount, animated: false)
                    }else {
                        strongSelf.goTo(0, animated: false)
                    }
                    
                }
            }
            print("page详情页收到通知:", "随控制器消失而取消注册")
            
        }
    }
    
    private func setupNavi() {
        if isEdit {
            self.title = "编辑"
            let button1Img = UIImage(named: "avatar")
            let barButton1 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(leftBarBtnClicked), ImageNormal: (button1Img?.scaled(toHeight: 20))!, ImageSel: (button1Img?.scaled(toHeight: 20))!)

            self.navigationItem.leftBarButtonItem = barButton1
        }else {
            self.title = "新建"
            //右侧按钮
//            let button1Img = UIImage(named: "avatar")
//            let barButton1 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(tap1), ImageNormal: (button1Img?.scaled(toHeight: 20))!, ImageSel: (button1Img?.scaled(toHeight: 20))!)
//
//            self.navigationItem.rightBarButtonItem = barButton1

        }
        
//        let buttonSave = UIBarButtonItem.creatBarButtonItemTitle(target: self, action: #selector(tap1), title: "已完成", titleColorNomal: .black, titleColorSel: .purple)
//        self.navigationItem.rightBarButtonItem = buttonSave
        
        //右侧按钮
        let button1Img = UIImage(named: "pdf")
        let barButton1 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(pdfSaveAndScan), ImageNormal: (button1Img?.scaled(toHeight: 28))!, ImageSel: (button1Img?.scaled(toHeight: 28))!)
        
        let button2Img = UIImage(named: "file-save")
        let barButton2 = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(fileSave), ImageNormal: (button2Img?.scaled(toHeight: 28))!, ImageSel: (button2Img?.scaled(toHeight: 28))!)
        
        //按钮间的空隙
        let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                  action: nil)
        gap.width = 15
        
        //用于消除右边边空隙，要不然按钮顶不到最边上
        let spacerRight = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                          action: nil)
        spacerRight.width = -10
        
        self.navigationItem.rightBarButtonItems = [spacerRight,barButton2,gap,barButton1]
      
    }
    
    @objc func pdfSaveAndScan() {
        print("pdf,folderItem =%@",parentFolderItem.folderPath!)
        if isEdit {
            guard let fileItem = editFileItem else {
                return
            }
            let imagePaths = fileItem.docPages.map {
                SHBFileTools.getNowFileFullPath(oldFullPath: $0.fileFullPath!)
            }
            let pdfPath = SHBFileTools.getNowFileFullPath(oldFullPath: fileItem.folderpath!) + "/" + "pic.pdf"
            let pdfUrl = URL(fileURLWithPath: pdfPath)
            if SHBFileManager.isFileExistAtpath(filepath: pdfPath) {
                showPDFDocument(pdfUrl: pdfUrl)
            }else {
                autoreleasepool {
                    do {
                        
                        //                    var images = [UIImage]()
                        //                    fileItem.docPages.forEach {
                        //                        images.append(UIImage(contentsOfFile: $0.fileFullPath!)!)
                        //                    }
                        
                        try PDFGenerator.generate(imagePaths, to: pdfPath)
                        
                        //                    if outputAsData {
                        //                        let data = try PDFGenerator.generated(by: images)
                        //                        try data.write(to: URL(fileURLWithPath: dst))
                        //                    } else {
                        //                        try PDFGenerator.generate(images, to: dst, dpi: .custom(144), password: "123456")
                        //                    }
                        //                    openPDFViewer(dst)
                        print("d")
                        showPDFDocument(pdfUrl: pdfUrl)
                    } catch let e {
                        print(e)
                    }
                }
            }
            
        }
        
        
    }
    
    private func showPDFDocument(pdfUrl:URL) {
        guard let pdfDocument = PDFDocument(url: pdfUrl) else {
            return
        }
        showDocument(pdfDocument)
    }
    
    private func showDocument(_ document: PDFDocument) {
        let image = UIImage(named: "")
        let controller = PDFViewController.createNew(with: document, title: "", actionButtonImage: image, actionStyle: .activitySheet)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func fileSave() {
        print("保存按钮点击1")
        setupNavi()
        if isEdit {
//            self.navigationController?.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController()
        }else {
            var docModel: DocFolderItem
            if let folderModel = SHBFileTools.unArchiveModel() {
                docModel = folderModel
            }else {
                docModel = buildRootModel()
            }
            docModel = buildDataModels(folderModel: docModel)
            
            if SHBFileTools.archiveModel(folderModel: docModel) {
                print("归档成功")
                NewNotifications.DocumentChangeNoti.post(())
            }else {
                print("归档失败")
            }
            
        }

        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func leftBarBtnClicked() {
        let vc = SettingOperateViewController()
        let navi = UINavigationController(rootViewController: vc)
        present(navi, animated: true, completion: nil)
        
    }
    
    private func getUpdateDocModels() -> DocFileItem? {
        var folderModel = SHBFileTools.unArchiveModel()
        var findIndex = -1
        var nowFileItem: DocFileItem?
        if editFileItem != nil {
            //根目录 查找
            for (index, item) in folderModel!.docFiles.enumerated() {
                if editFileItem == item {
                    findIndex = index
                    break
                }
            }
            if findIndex >= 0 {
                nowFileItem = folderModel!.docFiles[findIndex]
            }else {
                //二级目录 查找
                var folderIndex = -1
                for (index, folderItem) in folderModel!.docFolders.enumerated() {
                    let fileParentNowPath = SHBFileTools.getNowFileFullPath(oldFullPath: editFileItem!.parentPath)
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
                        if editFileItem == secfileitem {
                            fileIndex = secfileIndex
                            break
                        }
                    }
                    
                    if fileIndex >= 0 {
                        nowFileItem = destinFolder.docFiles[fileIndex]
                    }
                }
                
            }
        }
        return nowFileItem
    }
    
    private func buildRootModel() -> DocFolderItem {
        var docModel = DocFolderItem()
        docModel.folderIndex = 0
        docModel.folderName = "Root"
        docModel.folderPath = SHBFileTools.createRootFolder()!
        docModel.docFiles = [DocFileItem]()
        docModel.docFolders = [DocFolderItem]()
        docModel.timestampCreate = Date().unixTimestamp
        return docModel
    }
    
    private func buildDataModels(folderModel:DocFolderItem) -> DocFolderItem {
        let currentDate = Date()
        var docModel = folderModel
        let pagefolderName = "\(currentDate.unixTimestamp).page"
        let newPageFolderpath =  SHBFileTools.createFolderAtPath(path: parentFolderItem.folderPath!, folderName: pagefolderName)!
        var docPages = [DocPageItem]()
        for (index,pageModel) in initialImages.enumerated() {
            var docPageModel = DocPageItem()
            let scaleImageOri = pageModel.image?.scaled(toWidth: 375)
            let scaleChangeImage = scaleImageOri
            let filepath = newPageFolderpath + "/" + "\(index)" + ".png"
            let filepathOri = newPageFolderpath + "/" + "\(index)ori" + ".png"
            let success = SHBFileManager.writeObjectToFile(filepath: filepath, content: scaleImageOri as AnyObject,overwrite: true)
            let cSuccess = SHBFileManager.writeObjectToFile(filepath: filepathOri, content: scaleChangeImage as AnyObject,overwrite: true)
            if success && cSuccess {
                docPageModel.fileFullPath = filepath
                docPageModel.fileOriFullPath = filepathOri
                docPageModel.folderpath = newPageFolderpath
                docPageModel.parentPath = newPageFolderpath
                docPageModel.pageIndex = index
                docPageModel.filesuffix = ".png"
                docPageModel.timestampModifi = currentDate.unixTimestamp
                docPages.append(docPageModel)
            }else {
                print("文件写入出错")
            }
        }
        
        var docFile = DocFileItem()
        let currentFileCount = SHBFileTools.currentFileCount() + 1
        docFile.folderIndex = currentFileCount
        docFile.currentFolderIndex = 0
        SHBFileTools.updateFileCount(currentFileCount)
        docFile.docPages = docPages
        docFile.folderpath = newPageFolderpath
        docFile.parentPath = parentFolderItem.folderPath!
        docFile.timestampModifi = currentDate.unixTimestamp
        docFile.folderName = "new Item"
        
        var newFolderItem = parentFolderItem!
        newFolderItem.docFiles.append(docFile)
        
        //找到并替换相关folder数据
        var index = -1
        for (folderIndex, folderItem) in docModel.docFolders.enumerated() {
            if folderItem == parentFolderItem {
                index = folderIndex
            }
        }
        if index >= 0  {
            docModel.docFolders[index] = newFolderItem
        }else {
            docModel.docFiles.append(docFile)
        }
              
        return docModel
    }
    
    // MARK: - Layout
    func pageUpdate(currentNum:Int,totalNum:Int) {
        pageCountView.text = "\(currentNum)/\(totalNum)"
    }
    
    func configureLayout(_ size: CGSize) {
        scrollView.frame.size = size
//        scrollView.contentSize = CGSize(
//            width: size.width * CGFloat(numberOfPages) + spacing * CGFloat(numberOfPages - 1),
//            height: size.height)
        scrollView.contentSize = CGSize(
            width: size.width * CGFloat(numberOfPages) + spacing * CGFloat(numberOfPages - 1),
            height: 0)
        scrollView.contentOffset = CGPoint(x: CGFloat(currentPage) * (size.width + spacing), y: 0)
        
        for (index, pageView) in pageViews.enumerated() {
            var frame = scrollView.bounds
            frame.origin.x = (frame.width + spacing) * CGFloat(index)
//            pageView.frame = frame
            pageView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height - footViewHeight)
            pageView.configureLayout()
            if index != numberOfPages - 1 {
                pageView.frame.size.width += spacing
            }
        }
        
//        [headerView, footerView].forEach { ($0 as AnyObject).configureLayout() }

    }
    
    // MARK: - Configuration
    
    func configurePages(_ images: [SHBDocumentModel]) {
        pageViews.forEach { $0.removeFromSuperview() }
        pageViews = []
        
        let preloadIndicies = calculatePreloadIndicies()
        
        for i in 0..<images.count {
            let pageView = SHBPageView(docModel: preloadIndicies.contains(i) ? images[i] : SHBDocumentModel(image: UIImage(named: "")!))
            pageView.pageViewDelegate = self
            
            scrollView.addSubview(pageView)
            pageViews.append(pageView)
        }
        
        configureLayout(view.bounds.size)
    }
    
    // MARK: - Helper functions
    func calculatePreloadIndicies () -> [Int] {
        var preloadIndicies: [Int] = []
        let preload = SHBPageConfig.preload
        if preload > 0 {
            let lb = max(0, currentPage - preload)
            let rb = min(initialImages.count, currentPage + preload)
            for i in lb..<rb {
                preloadIndicies.append(i)
            }
        } else {
            preloadIndicies = [Int](0..<initialImages.count)
        }
        return preloadIndicies
    }
    
    // MARK: - Pagination    
    open func goTo(_ page: Int, animated: Bool = true) {
        guard page >= 0 && page < numberOfPages else {
            return
        }
        
        currentPage = page
        
        var offset = scrollView.contentOffset
        offset.x = CGFloat(page) * (scrollView.frame.width + spacing)
        
        let shouldAnimated = view.window != nil ? animated : false
        
        scrollView.setContentOffset(offset, animated: shouldAnimated)
    }
    
    open func next(_ animated: Bool = true) {
        goTo(currentPage + 1, animated: animated)
    }
    
    open func previous(_ animated: Bool = true) {
        goTo(currentPage - 1, animated: animated)
    }

}

extension SHBPageViewController: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var speed: CGFloat = velocity.x < 0 ? -2 : 2
        
        if velocity.x == 0 {
            speed = 0
        }
        
        let pageWidth = scrollView.bounds.width + spacing
        var x = scrollView.contentOffset.x + speed * 60.0
        
        if speed > 0 {
            x = ceil(x / pageWidth) * pageWidth
        } else if speed < -0 {
            x = floor(x / pageWidth) * pageWidth
        } else {
            x = round(x / pageWidth) * pageWidth
        }
        
        targetContentOffset.pointee.x = x
        currentPage = Int(x / pageWidth)
    }
}

extension SHBPageViewController: SHBPageViewDelegate {
    func pageViewDidTouch(_ pageView: SHBPageView) {
        
    }
    
    
}

extension SHBPageViewController: SHBFileOperateFootViewDelegate {
    
    func SHBFileOperateFootViewBtn(btn: UIButton) {

        fileOperateBtnClicked(btnIndex: btn.tag)
    }
    
    func fileOperateBtnClicked(btnIndex:Int) {
        switch btnIndex {
        case 0:
            editFile()
        case 1:
            recognizeFile()
        case 2:
            shareFile()
        case 3:
            addFile()
            //edit
        case 4:
            rerangeFile()
        case 5:
            deleteCurrentPage()
        default:
            print("btn clickded \(btnIndex)")
        }
    }
    
    func shareFile() {
//        let currentDoc = docModels[currentPage]
//
//        let image = currentDoc.image!
//        let vc = VisualActivityViewController(images: [image])
//
//        vc.previewImageSideLength = 160
//        vc.delegate = self
////        footView.disableBtnsIndex = [0,1,3]
//        presentActionSheet(vc,from: footerView)
        let alertTitle = "文件分享"
        let alertMessage = "请选择分享文件格式"
        let alertCancel = "取消"
        let alertImage = "图片"
        let alertPdf = "PDF"
        let alertTxt = "TXT"
        
        let alertSheet = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .actionSheet)
        // 2 命令（样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
        let cancelAction = UIAlertAction(title: alertCancel, style: .cancel, handler: nil)
        let imageAction = UIAlertAction(title: alertImage, style: .default, handler: { [weak self]
            action in
            self?.shareWithImage()
            print(alertImage)
        })
        let pdfAction = UIAlertAction(title: alertPdf, style: .default, handler: { [weak self]
            action in
            print(alertPdf)
        })
        let txtAction = UIAlertAction(title: alertTxt, style: .default, handler: { [weak self]
            action in
            print(alertTxt)
        })
        alertSheet.addAction(cancelAction)
        alertSheet.addAction(imageAction)
        alertSheet.addAction(pdfAction)
        alertSheet.addAction(txtAction)
        // 3 跳转
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertSheet.popoverPresentationController?.sourceView = self.view;
            alertSheet.popoverPresentationController?.sourceRect = CGRect(x: 0,y: SCREEN_HEIGHT,width: SCREEN_WIDTH,height: 1.0);
        }

        self.present(alertSheet, animated: true, completion: nil)
    }
    
    func shareWithImage() {
        let currentDoc = docModels[currentPage]
        
        let image = currentDoc.image!
        let vc = VisualActivityViewController(images: [image])
        
        vc.previewImageSideLength = 160
        vc.delegate = self
        //        footView.disableBtnsIndex = [0,1,3]
        presentActionSheet(vc,from: footerView)
    }
    
    private func presentActionSheet(_ vc: VisualActivityViewController, from view: UIView) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.popoverPresentationController?.sourceView = view
            vc.popoverPresentationController?.sourceRect = view.bounds
            vc.popoverPresentationController?.permittedArrowDirections = [.up, .down]
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    func editFile() {
        let currentDoc = docModels[currentPage]
        
        let vc = SHBPageEditViewController(image: currentDoc.image!)
        vc.delegate = self
        let navi = UINavigationController(rootViewController: vc)
        present(navi, animated: true, completion: nil)
    }
    
    func addFile() {
        let detectVC = DetectScanViewController(superFolderItem: parentFolderItem, fileItem: editFileItem)
        let navi = UINavigationController(rootViewController: detectVC)
        self.present(navi, animated: true, completion: nil)
    }
    func recognizeFile() {
        let recognizeVc = DocShowTableController()
        recognizeVc.textArr = ["dasdadsa","与大师的撒打算","wewe大的期望的","das撒的dsa","asdas与大师的撒打算","wewe望的"]
        let navi = UINavigationController(rootViewController: recognizeVc)
        self.present(navi, animated: true, completion: nil)
    }
    
    func rerangeFile() {
        print("rerangeFile")
        guard let fileItem = editFileItem else {
            return
        }
        let rerangeVC = PageRerangeViewController(fileModel: fileItem)
        rerangeVC.delegate = self
        self.navigationController?.pushViewController(rerangeVC)
    }
    
    func deleteCurrentPage()  {
        print("deleteCurrentPage")
        if editFileItem!.docPages.count > 1 {
            let alertVC = UIAlertController(title: "title", message: "msg", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
                if let strongSelf = self {
                    var fileItem = strongSelf.editFileItem!
                    let filePage = fileItem.docPages[self!.currentPage]
                    fileItem.docPages.remove(at: self!.currentPage)
                    strongSelf.docModels.remove(at: self!.currentPage)
                    let fileNowpath = SHBFileTools.getNowFileFullPath(oldFullPath: filePage.fileFullPath!)
                    let deleteSuccess = SHBFileManager.deleteFileAtPath(path: fileNowpath)
                    SHBFileTools.updateDocItemFile(fileModel: fileItem)
                    if deleteSuccess {
                        NewNotifications.DocumentChangeNoti.post(())
                        if self!.currentPage >= 1 {
                            strongSelf.goTo(self!.currentPage - 1, animated: false)
                        }else {
                            strongSelf.goTo(0, animated: false)
                        }
                    }
                    
                }
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            
            
            alertVC.addAction(actionOK)
            alertVC.addAction(actionCancel)
            
            present(alertVC, animated: true, completion: nil)
        }else {
            
        }


    }
    

}

extension SHBPageViewController: VisualActivityDelegate {
    func VisualActivityViewControllerWillDismiss() {
//        updateFootView()
    }
}

extension SHBPageViewController: PageRerangeViewControllerDelegate {
    func rerangeFileModel(filModel: DocFileItem) {
        editFileItem = filModel
    }
}

extension SHBPageViewController: SHBPageEditViewControllerDeleagte {
    func updateImage(editImage: UIImage,oriImage: UIImage) {
        let newDocModel = SHBDocumentModel(image: editImage)
        self.docModels[currentPage] = newDocModel
        if isEdit {
            print("go edit")
            let docPage = editFileItem!.docPages[currentPage]
            let imagePath = SHBFileTools.getNowFileFullPath(oldFullPath: docPage.fileFullPath!)
            let imageOriPath = SHBFileTools.getNowFileFullPath(oldFullPath: docPage.fileOriFullPath!)
            let success = SHBFileManager.writeObjectToFile(filepath: imagePath, content: editImage, overwrite: true)
            let oriSuccess = SHBFileManager.writeObjectToFile(filepath: imageOriPath, content: oriImage, overwrite: true)
            if success && oriSuccess{
                print("chenggong")
            }
        }
    }
}
//extension SHBPageViewController: SHBPageFootViewDelegate {
//    func SHBPageFootViewBtnClicekd(btnIndex: Int) {
//        print("button clicked tag \(btnIndex)")
//        let currentDoc = docModels[currentPage]
//
//        let vc = SHBPageEditViewController(image: currentDoc.image!)
//        let navi = UINavigationController(rootViewController: vc)
//        present(navi, animated: true, completion: nil)
//    }
//}


