//
//  SettingOperateViewController.swift
//  Scanpro1
//
//  Created by song on 2019/8/2.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

class SettingOperateViewController: UIViewController {    
    let cellID = "MyTableViewCell"
    
    fileprivate var tableDatas = [Dictionary<String,[SettingItem]>]()
    fileprivate lazy var tableView:UITableView? = {
        let myTableView = UITableView(frame: CGRect.zero, style: .grouped)
        myTableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: cellID)
//        myTableView.register(MyTableViewCell.self, forCellReuseIdentifier: cellID)
        myTableView.delegate = self
        myTableView.dataSource = self
        return myTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupNavi()
        setupUI()
    }
    
    private func setupData() {
        //购买
        let section1Name = "purchase"
        var section1Item = [SettingItem]()
        section1Item.append(SettingItem(image: "magic_filled", discribe: "discribe", type: .purchase))
        section1Item.append(SettingItem(image: "magic_filled", discribe: "discribe", type: .restore))
        let dic1 = [section1Name: section1Item]
        
        //相机默认滤镜设置
        let section2Name = "fliter"
        var section2Item = [SettingItem]()
        section2Item.append(SettingItem(image: "magic_filled", discribe: "discribe", type: .camerasetting))
        let dic2 = [section2Name: section2Item]
        
        //支持
        let section3Name = "share"
        var section3Item = [SettingItem]()
        section3Item.append(SettingItem(image: "magic_filled", discribe: "discribe", type: .support))
        section3Item.append(SettingItem(image: "magic_filled", discribe: "discribe", type: .share))
        section3Item.append(SettingItem(image: "magic_filled", discribe: "discribe", type: .tutorial))
        let dic3 = [section3Name: section3Item]
        
        //关于
        let section4Name = "about"
        var section4Item = [SettingItem]()
        section4Item.append(SettingItem(image: "magic_filled", discribe: "discribe", type: .about))
        section4Item.append(SettingItem(image: "magic_filled", discribe: "discribe", type: .privatepolicy))
        let dic4 = [section4Name: section4Item]
        
        tableDatas.append(dic1)
        tableDatas.append(dic2)
        tableDatas.append(dic3)
        tableDatas.append(dic4)
    }
    
    private func setupUI() {
        view.addSubview(self.tableView!)
        self.tableView!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(self.view)
        }
    }
    
    private func setupNavi() {
        self.navigationController?.navigationBar.setTitleFont(NAVIGATIONBAR_TITLE_FONT, color: NAVIGATIONBAR_TITLE_COLOR)
        self.navigationController?.navigationBar.setColors(background: NAVIGATIONBAR_RED_COLOR, text: NAVIGATIONBAR_TITLE_COLOR)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let leftBarButton = UIBarButtonItem.creatBarButtonItemTitle(target: self, action: #selector(dismissVC), title: "取消", titleColorNomal: .white, titleColorSel: .black)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

}

extension SettingOperateViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let indexDatas = self.tableDatas[section]
        let dickey = indexDatas.first?.key
        let dataArr = indexDatas[dickey!]
        return dataArr!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //获取单元格
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SettingCell
        cell.accessoryType = .disclosureIndicator
        
        //设置单元格内容
        let indexDatas = self.tableDatas[indexPath.section]
        let dickey = indexDatas.first?.key
        let dataArr = indexDatas[dickey!]
        let cellData = dataArr![indexPath.row]
        cell.itemData = cellData
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
