//
//  Constance.swift/Users/song-CV/Documents/ios-swift/Scanpro1/Scanpro1
//  Scanpro1
//
//  Created by song on 2019/6/21.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
/// 屏幕宽度
let SCREEN_WIDTH = UIScreen.main.bounds.width

/// 屏幕高度
let SCREEN_HEIGHT = UIScreen.main.bounds.height

/// 屏幕bounds
let SCREEN_BOUNDS = UIScreen.main.bounds

/// 导航栏背景颜色 - （红色）
let NAVIGATIONBAR_RED_COLOR = UIColor(red:0.831,  green:0.239,  blue:0.243, alpha:1)//211.905 60.945 61.965
//RGB颜色值转换成十六进制颜色码：#D43D3E

///
let NAVIGATIONBAR_TITLE_COLOR = UIColor.white
let NAVIGATIONBAR_TITLE_FONT = UIFont.systemFont(ofSize: 16)

///主文件夹
let NEWFOLDER_COUNT = 15 //可以创建最多15个文件夹
let CURRENT_FILE_COUNT_KEY = "CURRENT_FILE_COUNT_KEY"
let ROOT_FOLDER_NAME = "Common"

let CURRENT_FILE_ORDER_KEY = "CURRENT_FILE_ORDER_KEY" //0 
//let documentpath = SHBFileManager.getDocumentDirectory()
//let foldername = "Common"
//let folderSuccess = SHBFileManager.createFolderAtPath(folderName: foldername, pathUrl: NSURL(string: documentpath)!)
//let sccessStr = folderSuccess ? "成功": "失败"
//print("addFolder --\(foldername) --\(sccessStr) ")


