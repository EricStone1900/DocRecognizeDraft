//
//  DocShowTableController.swift
//  Scanpro1
//
//  Created by song on 2019/8/20.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class DocShowTableController: UITableViewController {
    
    var textArr = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
//        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        tableView.separatorColor = .lightGray
        tableView.register(UINib(nibName: "TextEidtCell", bundle: nil), forCellReuseIdentifier: TextEidtCell.identifier)
        setupNavi()
    }
    
    private func setupNavi() {
        self.navigationController?.navigationBar.setTitleFont(NAVIGATIONBAR_TITLE_FONT, color: NAVIGATIONBAR_TITLE_COLOR)
        self.navigationController?.navigationBar.setColors(background: NAVIGATIONBAR_RED_COLOR, text: NAVIGATIONBAR_TITLE_COLOR)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let leftBarButton = UIBarButtonItem.creatBarButtonItemTitle(target: self, action: #selector(dismissVC), title: "取消", titleColorNomal: .white, titleColorSel: .black)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        //右侧按钮
//        let button2Img = UIImage(named: "file-save")
//        let barButtonRight = UIBarButtonItem.creatBarButtonItemImagePic(target: self, action: #selector(save), ImageNormal: (button2Img?.scaled(toHeight: 28))!, ImageSel: (button2Img?.scaled(toHeight: 28))!,tag: 1002)
        
        let barButtonRight = UIBarButtonItem.creatBarButtonItemTitle(target: self, action: #selector(dismissVC), title: "保存", titleColorNomal: .white, titleColorSel: .black)
        
        
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
        self.navigationItem.rightBarButtonItems = [spacerRight,barButtonRight,gap,placeBarbtnOne]
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    private func createPdfFromView(aView: UIView, saveToDocumentsWithFileName fileName: String)
    {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil)
        UIGraphicsBeginPDFPage()
        
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
        
        aView.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentsFileName = documentDirectories + "/" + fileName
            debugPrint(documentsFileName)
            pdfData.write(toFile: documentsFileName, atomically: true)
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return textArr.count
    }
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextEidtCell.identifier, for: indexPath) as! TextEidtCell
        cell.docText = textArr[indexPath.row]
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
