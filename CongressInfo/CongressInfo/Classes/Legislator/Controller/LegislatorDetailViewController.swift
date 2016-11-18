//
//  LegislatorDetailViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/18/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class LegislatorDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var legislatorDetail = LegislatorModel()
    let detailTable = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        addChildView()
        detailTable.delegate = self
        detailTable.dataSource = self
        
        // Do any additional setup after loading the view.
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
        let profile = UIImage(data: self.legislatorDetail.profile)
        let profileView = UIImageView(image: profile)
        profileView.frame = CGRect(x: screenWidth * 0.3, y: 90, width: screenWidth * 0.4, height: screenHeight * 0.25)
        self.view.addSubview(profileView)
    }
    
    func addDetailTable() -> Void {
        self.view.addSubview(self.detailTable)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return initCellByValue(name: "First Name", value: self.legislatorDetail.first_name)
        case 1:
            return initCellByValue(name: "Last Name", value: self.legislatorDetail.last_name)
        case 2:
            return initCellByValue(name: "State", value: self.legislatorDetail.state)
        case 3:
            return initCellByValue(name: "Birth date", value: self.legislatorDetail.birthday)
        case 4:
            return initCellByValue(name: "Gender", value: self.legislatorDetail.gender)
        case 5:
            return initCellByValue(name: "Chamber", value: self.legislatorDetail.chamber)
        case 6:
            return initCellByValue(name: "Fax No.", value: self.legislatorDetail.fax)
        case 7:
            return initCellByValue(name: "Twitter", value: self.legislatorDetail.twitter)
        case 8:
            return initCellByValue(name: "Website", value: self.legislatorDetail.fax)
        case 9:
            return initCellByValue(name: "Office No.", value: self.legislatorDetail.office)
        case 10:
            return initCellByValue(name: "Term ends on", value: self.legislatorDetail.termEndOn)
        default:
            return initCellByValue(name: "", value: "")
        }
    }
    
    func initCellByValue(name : String, value : String) -> LegislatorDetailTableViewCell {
        if (value.characters.count > 0) {
            let cell = LegislatorDetailTableViewCell.initCellWithValue(name : "Fax No.", value : value)
            return cell
        } else {
            let cell = LegislatorDetailTableViewCell.initCellWithValue(name : "Fax No.", value : "N.A")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
