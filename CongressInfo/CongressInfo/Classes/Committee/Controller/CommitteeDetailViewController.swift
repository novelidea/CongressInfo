//
//  CommitteeDetailViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/18/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class CommitteeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var committeeDetail = CommitteeModel()
    let detailTable = UITableView(frame: CGRect(x: 10, y: screenHeight * 0.3, width: screenWidth - 20, height: screenHeight * 0.6))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        addChildView()
        detailTable.delegate = self
        detailTable.dataSource = self
        self.view.addSubview(self.detailTable)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addChildView() -> Void {
        addProfileImage()
        addDetailTable()
    }
    
    func addProfileImage() -> Void {
        //        let profile = UIImage(data: self.legislatorDetail.profile)
        //        let profileView = UIImageView(image: profile)
        let titleLabel = UILabel()
        titleLabel.text = committeeDetail.committee_name
        titleLabel.frame = CGRect(x: 10, y: 90, width: screenWidth - 20, height: screenHeight * 0.2)
        titleLabel.numberOfLines = 4
        titleLabel.sizeToFit()
        self.view.addSubview(titleLabel)
    }
    
    func addDetailTable() -> Void {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return initCellByValue(name: "ID", value: self.committeeDetail.committee_id)
        case 1:
            return initCellByValue(name: "Parent ID", value: self.committeeDetail.parent_committee)
        case 2:
            return initCellByValue(name: "Chamber", value: self.committeeDetail.chamber)
        case 3:
            return initCellByValue(name: "Office", value: self.committeeDetail.office)
        case 4:
            return initCellByValue(name: "Contact", value: self.committeeDetail.phone)
        default:
            return initCellByValue(name: "", value: "")
        }
    }
    
    func initCellByValue(name : String, value : String) -> BillDetailTableViewCell {
        if (value.characters.count > 0) {
//            if (name == "PDF") {
//                let cell = BillDetailTableViewCell.initCellWithValue(name : name, value : "PDF Link")
//                return cell
//            } else {
                let cell = BillDetailTableViewCell.initCellWithValue(name : name, value : value)
                return cell
//            }
        } else {
            let cell = BillDetailTableViewCell.initCellWithValue(name : name, value : "N.A")
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (indexPath.row == 4 && self.billDetail.pdf.characters.count > 0) {
//            UIApplication.shared.openURL(URL(string: self.billDetail.pdf)!)
//        }
//    }

}
