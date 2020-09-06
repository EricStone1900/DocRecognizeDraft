//
//  DocPageitem.swift
//  Scanpro1
//
//  Created by song on 2019/7/4.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
protocol DocFileProtocol {
    var folderIndex: Int { get set}
    var currentFolderIndex: Int { get set}
    var parentPath: String { get set}
}

struct DocPageItem: Codable{
    var pageIndex: Int = 0
    var timestampCreate: Double = 0  //时间戳
    var timestampModifi: Double = 0 //时间戳
    var fileFullPath: String?
    var fileOriFullPath: String?
//    var filePartPath: String?
    var rotatedAngle:CGFloat = 0
    var fileSize: String?
    var folderpath: String? 
    var filesuffix: String = ".png"
    var parentPath: String = ""
}
struct DocFileItem: Codable,DocFileProtocol{
    var folderIndex: Int = 0
    var currentFolderIndex: Int = 0
    var folderName: String?
    var parentPath: String = ""
    var folderpath: String? {
        didSet {
            if let newpath = folderpath {
                print("folderpath 的值从 \(String(describing: oldValue)) 更改为 \(newpath)")
                folderPartPath = SHBFileTools.cutStringFromStr(oriStr: newpath, fromStr: ROOT_FOLDER_NAME)
//                let folderPathURL = NSURL(string: newpath)!
//                let folderPathName = folderPathURL.lastPathComponent

                if docPages.count > 0 {
                    var newPages = [DocPageItem]()
                    for pageItem in docPages {
                        var temp = pageItem
//                        let pageFullURL = NSURL(string: pageItem.fileFullPath!)
//                        let pagePathName = pageFullURL!.lastPathComponent
                        let pagePathName = pageItem.fileFullPath!.lastPathComponent
                        temp.fileFullPath = newpath + "/" + pagePathName
                        newPages.append(temp)
                    }
                    docPages = newPages

                }
            }
        }
    }
    var folderPartPath: String?
    var timestampCreate: Double = 0 //时间戳
    var timestampModifi: Double = 0 //时间戳
    var docPages = [DocPageItem]()
    var foldersuffix: String = ".page"
    
}

struct DocFolderItem : DocFileProtocol{
    var folderIndex: Int = 0
    var currentFolderIndex: Int = 0
    var folderName: String?
    var parentPath: String = ""
    var folderPath: String? {
        didSet {
            print("DocFolderItem change")
            if let newpath = folderPath {
//                print("folderpath 的值从 \(String(describing: oldValue)) 更改为 \(newpath)")
                folderPartPath = SHBFileTools.cutStringFromStr(oriStr: newpath, fromStr: ROOT_FOLDER_NAME)
                
            }
        }
    }
    var folderPartPath: String?
    var timestampCreate: Double = 0  //时间戳
    var timestampModifi: Double = 0//时间戳
    var docFiles = [DocFileItem]()
    var docFolders = [DocFolderItem]()
    var foldersuffix: String = ".folder"
    enum CodingKeys: String, CodingKey  {
        case folderIndex
        case currentFolderIndex
        case folderName
        case folderPath
        case timestampCreate
        case timestampModifi
        case docFiles
        case foldersuffix
        case docFolders
        case folderPartPath
        case parentPath
    }
}

extension DocFolderItem: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(folderIndex, forKey: .folderIndex)
        try container.encode(currentFolderIndex, forKey: .currentFolderIndex)
        try container.encode(folderName, forKey: .folderName)
        try container.encode(folderPath, forKey: .folderPath)
        try container.encode(timestampCreate, forKey: .timestampCreate)
        try container.encode(timestampModifi, forKey: .timestampModifi)
        try container.encode(docFiles, forKey: .docFiles)
        try container.encode(foldersuffix, forKey: .foldersuffix)
        try container.encode(docFolders, forKey: .docFolders)
        try container.encode(folderPartPath, forKey: .folderPartPath)
        try container.encode(parentPath, forKey: .parentPath)
    }
}

extension DocFolderItem: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        folderIndex = try values.decode(Int.self, forKey: .folderIndex)
        currentFolderIndex = try values.decode(Int.self, forKey: .currentFolderIndex)
        folderName = try values.decode(String.self, forKey: .folderName)
        folderPath = try values.decode(String.self, forKey: .folderPath)
        timestampCreate = try values.decode(Double.self, forKey: .timestampCreate)
        timestampModifi = try values.decode(Double.self, forKey: .timestampModifi)
        docFiles = try values.decode([DocFileItem].self, forKey: .docFiles)
        foldersuffix = try values.decode(String.self, forKey: .foldersuffix)
        docFolders = try values.decode([DocFolderItem].self, forKey: .docFolders)
        folderPartPath = try values.decode(String.self, forKey: .folderPartPath)
        parentPath = try values.decode(String.self, forKey: .parentPath)
    }
}

extension DocFolderItem: Equatable {
    static func == (lhs: DocFolderItem, rhs: DocFolderItem) -> Bool {
        let lhsFullpath = lhs.folderPartPath!
        let rhsFullpath = rhs.folderPartPath!//getNowFileFullPath(oldFullPath: rhs.folderPath!)
        if lhsFullpath == rhsFullpath {
            return true
        }else {
            return false
        }
    }
    
}

extension DocFileItem: Equatable {
    static func == (lhs: DocFileItem, rhs: DocFileItem) -> Bool {
        let lhsFullpath = lhs.folderPartPath!//getNowFileFullPath(oldFullPath: lhs.folderpath!)
        let rhsFullpath = rhs.folderPartPath!//getNowFileFullPath(oldFullPath: rhs.folderpath!)
        if lhsFullpath == rhsFullpath {
            return true
        }else {
            return false
        }
    }
    
    
}
