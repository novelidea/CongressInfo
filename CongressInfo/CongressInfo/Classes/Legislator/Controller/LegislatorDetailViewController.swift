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
    let detailTable = UITableView(frame: CGRect(x: 10, y: screenHeight * 0.4, width: screenWidth - 20, height: screenHeight * 0.6))

    var likeButton = UIBarButtonItem()
    var isFavourited = false
    
    var delegate : FavouriteDataChangeProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        addChildView()
        detailTable.delegate = self
        detailTable.dataSource = self
        self.view.addSubview(self.detailTable)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        
        self.isFavourited = self.delegate.isLiked(bioguide_id: self.legislatorDetail.bioguide_id)
        updateRighBarButton(isFavourite: self.isFavourited)
    }
    
    func updateRighBarButton(isFavourite : Bool){
        let btnFavourite = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btnFavourite.addTarget(self, action: #selector(LegislatorDetailViewController.btnFavouriteDidClicked), for: .touchUpInside)
        if isFavourite {
            btnFavourite.setImage(UIImage(named: "liked"), for: .normal)
        }else{
            btnFavourite.setImage(UIImage(named: "unliked"), for: .normal)
        }
        let rightButton = UIBarButtonItem(customView: btnFavourite)
        self.navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }
    
    func btnFavouriteDidClicked()
    {
        //do your stuff
        self.isFavourited = !self.isFavourited;
        if self.isFavourited {
            self.favourite();
        }else{
            self.unfavourite();
        }
        self.updateRighBarButton(isFavourite: self.isFavourited);
    }
    
    
    func favourite()
    {
//        print("favourite")
        self.delegate.likeLegislator(legislator: self.legislatorDetail)
    }
    
    func unfavourite(){
//        print("unfavourite")
        self.delegate.unlikeLegislator(legislator: self.legislatorDetail)
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
            if (name == "Twitter") {
                let cell = LegislatorDetailTableViewCell.initCellWithValue(name : name, value : "Twitter Link")
                return cell
            } else if (name == "Website") {
                let cell = LegislatorDetailTableViewCell.initCellWithValue(name : name, value : "Website Link")
                return cell
            } else {
                let cell = LegislatorDetailTableViewCell.initCellWithValue(name : name, value : value)
                return cell
            }
            
        } else {
            let cell = LegislatorDetailTableViewCell.initCellWithValue(name : name, value : "N.A")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 7 || indexPath.row == 8) {
            if (indexPath.row == 7 && self.legislatorDetail.twitter.characters.count > 0) {
                let url = "https://twitter.com/" + self.legislatorDetail.twitter
                UIApplication.shared.openURL(URL(string: url)!)
            } else if (indexPath.row == 8 && self.legislatorDetail.website.characters.count > 0) {
                UIApplication.shared.openURL(URL(string: self.legislatorDetail.website)!)
            } else {
                let alert = UIAlertController(title: "Alert", message: "Link doesn't exist", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
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
