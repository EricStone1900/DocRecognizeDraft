//
//  SHBFileManager.swift
//  SuperApp
//
//  Created by song on 2019/6/18.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

public enum FileType: String {
    case directory = "directory"
    case gif = "gif"
    case jpg = "jpg"
    case png = "png"
    case jpeg = "jpeg"
    case json = "json"
    case pdf = "pdf"
    case plist = "plist"
    case file = "file"
    case sqlite = "sqlite"
    case log = "log"
    case txt = "txt"
    
    var fileName: String {
        switch self {
        case .directory: return "directory"
        case .jpg, .pdf, .gif, .jpeg: return "image"
        case .plist: return "plist"
        case .sqlite: return "sqlite"
        case .log: return "log"
        case .txt: return "txt"
        default: return "file"
        }
    }
}

class SHBFileManager: NSObject {
    // MARK:- 获取项目名称
    /// 获取项目名称
    class func getProjectName() -> String {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            return "unknown"
        }
        
        guard let projectName = infoDictionary[String(kCFBundleExecutableKey)] as? String else {
            return "unknown"
        }
        
        return  projectName
    }
    // MARK:- 获取用户目录 "HomeDir"
    /// 返回缓存根目录 "HomeDir"
    class func getHomeDirectory() -> String {
        let homeDirectory = NSHomeDirectory()
        return homeDirectory
    }
    
    // MARK:- 获取用户文档目录 "c"
    /// 返回缓存根目录 "document"
    class func getDocumentDirectory() -> String {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return "documentPath error"
        }
        return documentPath
    }
    
    
    // MARK:- 返回缓存根目录 "caches"
    /// 返回缓存根目录 "caches"
    class func getCachesDirectory() -> String {
        guard let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return "cachesPath error"
        }
        
        return cachesPath
    }
    
    // MARK:- 返回Library根目录 "Library"
    /// 返回缓存根目录 "Library"
    class func getLibraryDirectory() -> String {
        guard let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last else {
            return "libraryPath error"
        }
        return libraryPath
    }
    
    // MARK:- 返回Preference根目录 "Preference"
    /// 返回缓存根目录 "Preference"
    class func getPreferenceDirectory() -> String {
        let libraryPath = getLibraryDirectory()
        return libraryPath + "/" + "Preferences"
    }
    
    // MARK:- 返回Temp根目录 "Temp"
    /// 返回缓存根目录 "Temp"
    class func getTempDirectory() -> String {
        let tempPath = NSTemporaryDirectory()
        return tempPath
    }
    
    // MARK: 遍历文件夹
    class func listFilesInDirectoryAtPath(path:String,deep:Bool) -> [String]? {
        if deep {
            //            let enumeratorAtPath = FileManager.default.enumerator(atPath: path)
            //            return enumeratorAtPath?.allObjects as? [String]
            let enumeratorAtPath = FileManager.default.subpaths(atPath: path)
            return enumeratorAtPath
        }else {
            let contentsOfPath = try? FileManager.default.contentsOfDirectory(atPath: path)
            return contentsOfPath
            
        }
    }
    
    // MARK: 遍历用户文件夹
    class func listFilesInHomeDirectoryByDeep(deep:Bool) -> [String]? {
        return listFilesInDirectoryAtPath(path: getHomeDirectory(), deep: deep)
    }
    
    // MARK: 遍历Document文件夹
    class func listFilesInDocumentDirectoryByDeep(deep:Bool) -> [String]? {
        return listFilesInDirectoryAtPath(path: getDocumentDirectory(), deep: deep)
    }
    
    // MARK: 遍历Library文件夹
    class func listFilesInLibraryDirectoryByDeep(deep:Bool) -> [String]? {
        return listFilesInDirectoryAtPath(path: getLibraryDirectory(), deep: deep)
    }
    
    // MARK: 遍历Caches文件夹
    class func listFilesInCachesDirectoryByDeep(deep:Bool) -> [String]? {
        return listFilesInDirectoryAtPath(path: getCachesDirectory(), deep: deep)
    }
    
    // MARK: 遍历Temp文件夹
    class func listFilesInTmpDirectoryByDeep(deep:Bool) -> [String]? {
        return listFilesInDirectoryAtPath(path: getTempDirectory(), deep: deep)
    }
    
    
    /*-----------------------------------创建文件夹-------------------------------------*/
//    class func createFolderAtPath(folderName:String,pathUrl:NSURL) -> Bool {
//        let folder = pathUrl.appendingPathComponent(folderName,isDirectory: true)
//        let exist = FileManager.default.fileExists(atPath: folder!.path)
//        var success = false
//        if !exist {
//            do {
//                try FileManager.default.createDirectory(atPath: folder!.path, withIntermediateDirectories: true, attributes: nil)
//                success = true
//            }catch{
//                print(error.localizedDescription)
//                success = false
//            }
//
//        }else {
//            success = true
//        }
//        return success
//    }
    
    class func createFolderAtPath(folderName:String,pathStr:String) -> Bool {
        let folder = pathStr.appendingPathComponent(folderName)
        let exist = FileManager.default.fileExists(atPath: folder)
        var success = false
        if !exist {
            do {
                try FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
                success = true
            }catch{
                print(error.localizedDescription)
                success = false
            }
            
        }else {
            success = true
        }
        return success
    }
    
    
    class func createFolderAtHomeDir(folderName:String) -> Bool {
        let homepath = getHomeDirectory()
//        return createFolderAtPath(folderName: folderName, pathUrl: NSURL(string: homepath)!)
        return createFolderAtPath(folderName: folderName, pathStr: homepath)
    }
    
    class func createFolderAtDocDir(folderName:String) -> Bool {
        let docpath = getDocumentDirectory()
//        return createFolderAtPath(folderName: folderName, pathUrl: NSURL(string: docpath)!)
        return createFolderAtPath(folderName: folderName, pathStr: docpath)
    }
    
    class func createFolderAtCacheDir(folderName:String) -> Bool {
        let cachepath = getCachesDirectory()
//        return createFolderAtPath(folderName: folderName, pathUrl: NSURL(string: cachepath)!)
        return createFolderAtPath(folderName: folderName, pathStr: cachepath)
    }
    
    /*-----------------------------------创建文件-------------------------------------*/
    // MARK: 创建文件（默认文本都用txt）
    class func createFileAtPath(filepath:String) -> Bool {
        //文件同名不做操作
        let exist = FileManager.default.fileExists(atPath: filepath)
        if !exist {
            let data = Data(base64Encoded:"aGVsbG8gd29ybGQ=" ,options:.ignoreUnknownCharacters)
            let createSuccess = FileManager.default.createFile(atPath: filepath, contents: data, attributes: nil)
            return createSuccess
        }else {
            return true
        }
    }
    
    class func writeObjectToFile(filepath:String,content:AnyObject, overwrite:Bool) -> Bool{
        var success = false
        let exist = FileManager.default.fileExists(atPath: filepath)
        if exist {
            if !overwrite {
                print("文件已经存在，不允许复写")
                return false
            }
//            print("文件已经存在，允许复写")
            do {
                if (content is String) {
                    let contentString = content as! String
                    try contentString.write(toFile: filepath, atomically: true, encoding: String.Encoding.utf8)
                }else if (content is UIImage) {
                    let contentImg = content as! UIImage
                    let imageData = UIImagePNGRepresentation(contentImg)!
                    try imageData.write(to: URL(fileURLWithPath: filepath))
                }else if (content is NSArray) {
                    let contentArr = content as! NSArray
                    contentArr.write(toFile: filepath, atomically: true)
                }else if (content is NSDictionary) {
                    let contentDic = content as! NSDictionary
                    contentDic.write(toFile: filepath, atomically: true)
                }
                success = true
            } catch  {
                success = false
            }
        }else {
            let data = Data(base64Encoded:"aGVsbG8gd29ybGQ=" ,options:.ignoreUnknownCharacters)
            let createSuccess = FileManager.default.createFile(atPath: filepath, contents: data, attributes: nil)
            if createSuccess {
                success = writeObjectToFile(filepath: filepath, content: content,overwrite: true)
            }else {
                success = false
            }
        }
        return success
        
    }
    
    /*-----------------------------------读取文件类型-------------------------------------*/
    class func getFileType(filepath:String) -> FileType{
        var isDir: ObjCBool = ObjCBool(false)
        FileManager.default.fileExists(atPath: filepath, isDirectory: &isDir)
        let fileExtension = URL(fileURLWithPath: filepath).pathExtension.lowercased()
        let fileType: FileType = isDir.boolValue ? .directory : FileType(rawValue: fileExtension) ?? .file
        return fileType
    }
    
    class func fileSizeToString(fileSize:NSNumber) -> String {
        let sizeNum = fileSize.intValue
        // bytes
        if sizeNum < 1023 {
            return String(format: "%lu bytes", CUnsignedLong(sizeNum))
        }
        // KB
        var floatSize = Float(sizeNum / 1024)
        if floatSize < 1023 {
            return String(format: "%.1f KB", floatSize)
        }
        // MB
        floatSize = floatSize / 1024
        if floatSize < 1023 {
            return String(format: "%.1f MB", floatSize)
        }
        // GB
        floatSize = floatSize / 1024
        return String(format: "%.1f GB", floatSize)
    }
    
    /*-----------------------------------文件相关参数 获取文件属性-------------------------------------*/
    class func isFileExistAtpath(filepath:String) -> Bool {
        return FileManager.default.fileExists(atPath: filepath)
    }
    
    //是否为文件夹
    class func isDirectory(path:String) -> Bool {
        guard let value = attributeOfItemAtPath(path: path, key: .type) else {
            return false
        }        
        return (value as! String) == "NSFileTypeDirectory"
    }
    
    class func isDirectoryEmpty(folderpath:String) -> Bool {
        if !isDirectory(path: folderpath) {
            return true
        }
        guard let subFileArr = listFilesInDirectoryAtPath(path: folderpath, deep: false) else {
            print("输入的不是文件夹路径")
            return true
        }
        
        return (subFileArr.count == 0)
    }
    
    class func attributeOfItemAtPath(path:String, key:FileAttributeKey) -> Any?{
        guard let attriDic = attributesOfItemAtPath(path: path) else {
            return nil
        }
        return attriDic[key]
    }
    
    class func attributesOfItemAtPath(path:String) -> [FileAttributeKey : Any]?{
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch (let error) {
            print("File size error: \(error.localizedDescription)")
            return nil
        }
    }
    
    /*-----------------------------------获取文件(夹)大小-------------------------------------*/
    class func sizeOfFileAtPath(path:String) -> NSNumber?{
        guard let attri = attributeOfItemAtPath(path: path, key: .size) else {
            print("文件大小读取出错")
            return nil
        }
        return (attri as! NSNumber)
    }
    
    class func sizeOfDirectoryAtPath(path:String) -> NSNumber?{
        if isFileExistAtpath(filepath: path) {
            let subPaths = listFilesInDirectoryAtPath(path: path, deep: true)!
            var folderSize = 0
            for (_,value) in subPaths.enumerated() {
//                 print("index:\(index),value:\(value)")
                let filepath = path + "/" + value
                let filesize = sizeOfFileAtPath(path: filepath) ?? NSNumber(value: 0)
                print("filepath = \(filepath)")
                print("filesize = \(filesize)")
                folderSize += filesize.intValue
            }
            return NSNumber(value: folderSize)
        }else {
            return nil
        }
    }
    
    
     /*-----------------------------------文件操作-------------------------------------*/
    class func copyFileToPath(fromPath:String,toPath:String) -> Bool {
        do {
            try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    class func moveFileToPath(fromPath:String,toPath:String) -> Bool{
        do {
            try FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    class func deleteFileAtPath(path:String) -> Bool{
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
}
    

