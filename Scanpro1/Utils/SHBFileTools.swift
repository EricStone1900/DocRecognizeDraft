//
//  SHBFileTools.swift
//  Scanpro1
//
//  Created by song on 2019/7/8.
//  Copyright © 2019 song. All rights reserved.
//

import Foundation
class SHBFileTools {
    //根文件夹
    static func createRootFolder() -> String? {
        let foldername = "Common"
        let documentFloderPath = SHBFileManager.getDocumentDirectory()
        var rootPath = documentFloderPath + "/" + foldername
        if SHBFileManager.isFileExistAtpath(filepath: rootPath) {
            return rootPath
        }
        
//        let folderSuccess = SHBFileManager.createFolderAtPath(folderName: foldername, pathUrl: NSURL(string: documentFloderPath)!)
        let folderSuccess = SHBFileManager.createFolderAtPath(folderName: foldername, pathStr: documentFloderPath)
        if !folderSuccess {
            rootPath = ""
        }
        
        return rootPath
    }
    
    //创建自定义临时文件夹
    static func createTempFolderAtRoot() -> String {
        let rootPath = createRootFolder()!
        var folderPath = rootPath + "/" + "Temp"
        if SHBFileManager.isFileExistAtpath(filepath: folderPath) {
            return folderPath
        }
        let createSuccess = SHBFileManager.createFolderAtPath(folderName: "Temp", pathStr: rootPath)
        if !createSuccess {
            folderPath = ""
        }
        return folderPath
    }
    
    static func clearTempFolder() {
        let foldername = "Common"
        let documentFloderPath = SHBFileManager.getDocumentDirectory()
        let rootPath = documentFloderPath + "/" + foldername
        let tempPath = rootPath + "/" + "Temp"
        _ = SHBFileManager.deleteFileAtPath(path: tempPath)
    }
    
    static func createFolderAtRoot(folderName: String) -> String? {
        let rootPath = createRootFolder()!
        var folderPath = rootPath + "/" + folderName
        if SHBFileManager.isFileExistAtpath(filepath: folderPath) {
            return folderPath
        }
//        let createSuccess = SHBFileManager.createFolderAtPath(folderName: folderName, pathUrl: NSURL(string: rootPath)!)
                let createSuccess = SHBFileManager.createFolderAtPath(folderName: folderName, pathStr: rootPath)
        if !createSuccess {
            folderPath = ""
        }
        return folderPath
    }
    
    static func createFolderAtPath(path: String, folderName: String) -> String? {
        var folderPath = path + "/" + folderName
        if SHBFileManager.isFileExistAtpath(filepath: folderPath) {
            return folderPath
        }
        let createSuccess = SHBFileManager.createFolderAtPath(folderName: folderName, pathStr: path)
        if !createSuccess {
            folderPath = ""
        }
        return folderPath
    }
    
    static func getRootFolderChildCount() -> Int {
        guard let folderPath = createRootFolder() else {
            return 0
        }
        return SHBFileManager.listFilesInDirectoryAtPath(path: folderPath, deep: false)?.count ?? 0
    }
    
    static func getFolderChildCountAtPath(folderpath: String) -> Int {
         return SHBFileManager.listFilesInDirectoryAtPath(path: folderpath, deep: false)?.count ?? 0
    }
    
    static func getMainJsonpath() -> String {
        let documentFolderPath = SHBFileManager.getDocumentDirectory()
        let mainJsonName = "main.json"
        let path = documentFolderPath + "/" + mainJsonName
        return path
    }
    
    //解档
    static func unArchiveModel() -> DocFolderItem? {
        var docFolderModel: DocFolderItem?
        
        let mainJsonPath = SHBFileTools.getMainJsonpath()
        if SHBFileManager.isFileExistAtpath(filepath: mainJsonPath) {
            let data = FileManager.default.contents(atPath: mainJsonPath)
            let jsonString = String(data: data!, encoding: .utf8)
            print("jsonString:\(jsonString!)");
            let jsonDecoder = JSONDecoder()
            let folderModel = try! jsonDecoder.decode(DocFolderItem.self, from: data!)
            docFolderModel = folderModel
        }
        return docFolderModel
    }
    
    //归档
    
    static func archiveModel(folderModel:DocFolderItem) -> Bool{
        let mainJsonPath = SHBFileTools.getMainJsonpath()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(folderModel)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        let jsonfileSave = SHBFileManager.writeObjectToFile(filepath: mainJsonPath, content: jsonString as AnyObject, overwrite: true)
        return jsonfileSave
    }
    
    static func getNowFileFullPath(oldFullPath: String) -> String {
        let range: Range = oldFullPath.range(of: "Common")!
        let location: Int = oldFullPath.distance(from: oldFullPath.startIndex, to: range.lowerBound)
        let partStr = oldFullPath.suffix(oldFullPath.count - location)
        let documentFloderPath = SHBFileManager.getDocumentDirectory()
        let newPath = documentFloderPath + "/" + partStr
        return newPath
    }
    
    static func cutStringFromStr(oriStr: String, fromStr: String) -> String? {
        guard let range: Range = oriStr.range(of: fromStr) else {
            return nil
        }
        let location: Int = oriStr.distance(from: oriStr.startIndex, to: range.lowerBound)
        let partStr = oriStr.suffix(oriStr.count - location)
        return String(partStr)
    }
    
    static func updateDocItemFile(fileModel: DocFileItem){
        let fileItemModel = fileModel
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
    }
    
//    //from: 需要替换的Str
//    //to: 替换成的Str
//    static func relpaceStringFromStr(oriStr: String, fromStr: String, toStr: String) -> String? {
//        guard let range: Range = oriStr.range(of: fromStr) else {
//            return nil
//        }
//        let location: Int = oriStr.distance(from: oriStr.startIndex, to: range.lowerBound)
//        let newStr = oriStr.subs
//        
//    }

    
    static func folderAlreadyHave(folderName:String,parentFolderPath:String) -> Bool {
        let filepaths = SHBFileManager.listFilesInDirectoryAtPath(path: parentFolderPath, deep: false)
        return (filepaths?.contains(folderName))!
    }
    
    
    static func folderCount(folderName:String,parentFolderPath:String) -> Int {
//        let filepaths = SHBFileManager.listFilesInDirectoryAtPath(path: parentFolderPath, deep: false)
//        let testStr = "dsadsadsa(2)"
//        let startIndex = testStr.index(of: "(")
//        let toIndex = testStr.index(of: ")")
//        let fromIndex = testStr.index(startIndex!, offsetBy: 1)
        
        
//        let filepaths = ["dsad","2123","ewqd","aaa(2)","aaa","aaa(10)","fdfd","aaa(3)"]
//        let removeIndexpaths = filepaths.map { $0[$0.startIndex..<($0.index(of: "(") ?? $0.endIndex)]
//        }
        
        let testInt = [1,2,3,4]
        let ss = missingNumber(testInt)
        
        var set1: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
        var set2: Set<Int> = [1, 3, 5, 7]
        
        let a1 = set1.intersection(set2) //交集
        let a2 = set1.union(set2) //并集
        let a3 = set1.subtracting(set2) //差集
        var arry = Array(a3)
        arry.sort(by: {$0<$1})
        return 0
    }
    
    static func getNewFolderName(baseNewName:String,parentFolderPath:String) -> String {
        guard let filepaths = SHBFileManager.listFilesInDirectoryAtPath(path: parentFolderPath, deep: false) else {
            return baseNewName
        }
        
        //新建文件夹 第一个不带后缀 第二个从 2 开始计数
        let leftChar: Character = "("
        let rightChar: Character = ")"
        if filepaths.contains(baseNewName) { //已经存在
            //找到连续的缺失的文件夹
            var folderIndex = [Int]()
            for names in filepaths {
                if names.contains(leftChar) && names.contains(rightChar) {
                    let startIndex = names.index(of: leftChar)!
                    let toIndex = names.index(of: rightChar)!
                    let fromIndex = names.index(startIndex, offsetBy: 1)
                    let indexStr = names[fromIndex..<toIndex]
                    let indexInt = Int(indexStr) ?? 0
                    folderIndex.append(indexInt)
                }
            }
            if folderIndex.isEmpty {
                let currentIndex = 2
                let currentSuf = "(\(currentIndex))"
                return "\(baseNewName)\(currentSuf)"
            } else if folderIndex.count == 1 {
                let firstIndex = folderIndex.first!
                let currentIndex = firstIndex == 2 ? 3 : firstIndex - 1
                let currentSuf = "(\(currentIndex))"
                return "\(baseNewName)\(currentSuf)"
            } else {
                folderIndex.sort(by: {$0<$1})
                let wholeArr = [Int](2...folderIndex.last!)
                let wholeSet = Set(wholeArr)
                let currentSet = Set(folderIndex)
                let subSet = wholeSet.subtracting(currentSet)
                var subArr = Array(subSet)
                subArr.sort(by: {$0<$1})
                var currentIndex: Int?
                if subArr.isEmpty {
                    currentIndex = folderIndex.last! + 1
                } else {
                    currentIndex = subArr.first!
                }
                let currentSuf = "(\(currentIndex!))"
                return "\(baseNewName)\(currentSuf)"
            }
            
        }else {
            return baseNewName
        }
    }
    
    static func missingNumber(_ nums: [Int]) -> Int {
        var res = 0
        for i in 0..<nums.count {
            res ^= (i + 1) ^ nums[i]
        }
        return res
    }
    
    static func currentFileCount() -> Int {
        let userDefult = UserDefaults.standard
        let fileCount = userDefult.integer(forKey: CURRENT_FILE_COUNT_KEY)
        return fileCount
    }
    
    static func updateFileCount(_ fileNum:Int) {
        let userDefult = UserDefaults.standard
        userDefult.set(fileNum, forKey: CURRENT_FILE_COUNT_KEY)
    }
    
//    static func orderedBy() -> Int {
//        
//    }
    
    
    
//    static func getStrfrom() {
//        let str = "dsasdas"
//        let ss = str.index(of: "(")
//        str[ss!..<str.endIndex]
//    }
    
//    static func buildDocDataWithModel(docModel: DocFolderItem) {
//        var docFolderModel = SHBFileTools.unArchiveModel()
//        if docFolderModel != nil {
//            let rootPath = createRootFolder()
//            for folderItem in docFolderModel!.docFolders {
//                
//
//            }
//            
//            
//        }else {
//            var docModel = DocFolderItem()
//            docModel.folderIndex = 0
//            docModel.folderName = "Root"
//            docModel.folderPath = createRootFolder()
//            docModel.docFiles = [DocFileItem]()
//            docModel.docFolders = [DocFolderItem]()
//            docModel.timestampCreate = Date().unixTimestamp
//        }
//    }
    
    
}
