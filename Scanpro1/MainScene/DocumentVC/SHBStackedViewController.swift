//
//  SHBFStackedViewController.swift
//  SuperApp
//
//  Created by song on 2019/6/19.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import StackedCollectionView
//import SwifterSwift
class SHBStackedViewController: UIViewController {
//    var items: [Any] = Item.getArray()
    var items = [Any]()
    
    let collectionView: UICollectionView = {
        let flowLayout = CustomFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTestData()
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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupTestData() {
//        let docPage1 = DocPageItem(image: UIImage(named: "back")!)
//        docPage1.name = "docPage1"
//        let docPage2 = DocPageItem(image: UIImage(named: "PhotoCover")!)
//        docPage2.name = "docPage1"
//
//        let docFile1 = DocFileItem()
//        docFile1.fileName = "docFile1"
//        docFile1.filePath = ""
//        docFile1.docPage = [docPage2,docPage1]
//
//        let docFile2 = DocFileItem()
//        docFile2.fileName = "docFile2"
//        docFile2.filePath = ""
//        docFile2.docPage = [docPage1]
//
//        let docFolder1 = DocFolderItem()
//        docFolder1.docFile = [docFile1]
//        docFolder1.folderName = ""
//
//        let docFolder2 = DocFolderItem()
//        docFolder2.docFile = []
//        docFolder2.folderName = ""
//
//        items.append(docFolder1)
//        items.append(docFolder2)
//        items.append(docFile2)
        
    }
/*----------------------------------------测试--------------------------------------------------*/
//    func test() {
//        let image1 = UIImage(named: "LaunchImage")
////        let timeNow = Date()
////        timeNow.
//        let testFile1 = SHBFile(parentFolderName: "testFolder1", filename: "dsad.png", timestampCreate: 343243, timestampModifi: nil, fileFullPath: "sdasads", fileSize: nil)
//        let testFolder1 = SHBFolder(foldername: "testFolder1", timestampCreate: 12121212, timestampModify: nil, childFiles: nil)
//    }
//    
//    func createFolder() {
//        
//    }
//    
//    func createFileAtCommonFolder() {
//        let image1Name = "Layers.png"
//        let image1 = UIImage(named: image1Name)
//        
//        let documentpath = SHBFileManager.getDocumentDirectory()
//        let success = SHBFileManager.createFolderAtPath(folderName: "common", pathUrl: NSURL(string: documentpath)!)
//    }


}

/*----------------------------------------测试--------------------------------------------------*/


extension SHBStackedViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
//        if let item = items[indexPath.item] as? Item {
//            cell.items = [item]
//        } else if let items = items[indexPath.item] as? [Item] {
//            cell.items = items
//        }
        
//        if let item = items[indexPath.item] as? DocFolderItem {
//            cell.items = [item]
//        } else if let items = items[indexPath.item] as? [Item] {
//            cell.items = items
//        }
        cell.item = items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = items[sourceIndexPath.item]
        items.remove(at: sourceIndexPath.item)
        items.insert(item, at: destinationIndexPath.item)
    }
   
}

extension SHBStackedViewController: StackedCollectionViewDelegate,StackedCollectionViewDataSource {
    func collectionViewGestureDidMoveOutsideTriggerRadius(_ collectionView: UICollectionView) {
        print("Gesture moved outside trigger radius")
    }
    
    func collectionView(_ collectionView: UICollectionView, animationControllerFor indexPath: IndexPath) -> UICollectionViewCellAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt sourceIndexPath: IndexPath, into stackDestinationIndexPath: IndexPath) -> Bool {
//        if
//            items[sourceIndexPath.item] is [Item], // Block moving a stack...
//            items[stackDestinationIndexPath.item] is Item // ...onto an item.
//        {
//            return false
//        }
//        return true
        
//        let souceItem = items[sourceIndexPath.item]
        let stackDestinItem = items[stackDestinationIndexPath.item]
        if (stackDestinItem is DocFileItem) {
            return false
        }
//        let bothFolder = (souceItem is DocFolderItem) && (stackDestinItem is DocFolderItem)
//        let souceFile = (souceItem is DocFileItem) && (stackDestinItem is DocFolderItem)
//        if souceFile || bothFolder {
//            return true
//        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, into stackDestinationIndexPath: IndexPath) {
        
        print("Add item at index \(sourceIndexPath.item) into index \(stackDestinationIndexPath.item).")
        
//        if let sourceItem = items[sourceIndexPath.item] as? Item {
//
//            if let destinationItem = items[stackDestinationIndexPath.item] as? Item {
//
//                items[stackDestinationIndexPath.item] = [sourceItem, destinationItem]
//                items.remove(at: sourceIndexPath.item)
//
//            } else if let destinationStack = items[stackDestinationIndexPath.item] as? [Item] {
//
//                items[stackDestinationIndexPath.item] = destinationStack + [sourceItem]
//                items.remove(at: sourceIndexPath.item)
//
//            }
//
//        } else if let sourceStack = items[sourceIndexPath.item] as? [Item] {
//
//            if let destinationItem = items[stackDestinationIndexPath.item] as? Item {
//
//                items[stackDestinationIndexPath.item] = sourceStack + [destinationItem]
//                items.remove(at: sourceIndexPath.item)
//
//            } else if let destinationStack = items[stackDestinationIndexPath.item] as? [Item] {
//
//                items[stackDestinationIndexPath.item] = sourceStack + destinationStack
//                items.remove(at: sourceIndexPath.item)
//
//            }
//
//        }
        

        if let souceItem = items[sourceIndexPath.item] as? DocFileItem {
            if let stackDestinItem = items[stackDestinationIndexPath.item] as? DocFolderItem {
                var newFolderModel = stackDestinItem
                newFolderModel.folderName = "join new Item"
                newFolderModel.docFiles.append(souceItem)
                items[stackDestinationIndexPath.item] = newFolderModel
                items.remove(at: sourceIndexPath.item)
            }
        }else if let souceItem = items[sourceIndexPath.item] as? DocFolderItem {
            if let stackDestinItem = items[stackDestinationIndexPath.item] as? DocFolderItem {
                var newFolderModel = stackDestinItem
                newFolderModel.folderName = "new join folder"
                newFolderModel.docFiles = newFolderModel.docFiles + souceItem.docFiles
                items[stackDestinationIndexPath.item] = newFolderModel
                items.remove(at: sourceIndexPath.item)
            }
        }
 
    }
    
    func collectionView(_ collectionView: UICollectionView, finishMovingItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Move item from index \(sourceIndexPath.item) to index \(destinationIndexPath.item).")
    }
    
}
