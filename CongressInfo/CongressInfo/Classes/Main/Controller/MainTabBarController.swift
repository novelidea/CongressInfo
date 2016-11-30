//
//  MainTabBarController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/16/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

protocol FavouriteDataChangeProtocol {
    // legislator delegate
    func likeLegislator(legislator : LegislatorModel)
    func unlikeLegislator(legislator : LegislatorModel)
    func isLiked(bioguide_id : String) -> Bool
    func getFavouriteLegislators() -> [LegislatorModel]
    
    // bill delegate
    func likeBill(bill : BillModel)
    func unlikeBill(bill : BillModel)
    func isLikedBill(bill_id : String) -> Bool
    func getFavouriteBills() -> [BillModel]
    
    // commit delegate
    func likeCommittee(committee : CommitteeModel)
    func unlikeCommittee(committee : CommitteeModel)
    func isLikedCommittee(committee_id : String) -> Bool
    func getFavouriteCommittees() -> [CommitteeModel]
}

class MainTabBarController: UITabBarController, MenuItemDelegate, UITabBarControllerDelegate, FavouriteDataChangeProtocol {
    // committee delegate
    internal func getFavouriteCommittees() -> [CommitteeModel] {
        return self.committeeFavourites
    }

    internal func isLikedCommittee(committee_id: String) -> Bool {
        if (self.committeeFavourites.count == 0) {
            return false
        }
        for index in (0 ... self.committeeFavourites.count - 1) {
            if (self.committeeFavourites[index].committee_id == committee_id) {
                return true
            }
        }
        return false
    }

    internal func unlikeCommittee(committee: CommitteeModel) {
        for index in (0 ... self.committeeFavourites.count - 1) {
            if (self.committeeFavourites[index].committee_id == committee.committee_id) {
                self.committeeFavourites.remove(at: index)
                break
            }
        }
    }

    internal func likeCommittee(committee: CommitteeModel) {
        self.committeeFavourites.append(committee)
    }

    // bill delegate
    internal func getFavouriteBills() -> [BillModel] {
        return self.billFavourites
    }

    internal func isLikedBill(bill_id: String) -> Bool {
        if (self.billFavourites.count == 0) {
            return false
        }
        for index in (0 ... self.billFavourites.count - 1) {
            if (self.billFavourites[index].bill_id == bill_id) {
                return true
            }
        }
        return false
    }

    internal func unlikeBill(bill: BillModel) {
        for index in (0 ... self.billFavourites.count - 1) {
            if (self.billFavourites[index].bill_id == bill.bill_id) {
                self.billFavourites.remove(at: index)
                break
            }
        }
    }

    internal func likeBill(bill: BillModel) {
        self.billFavourites.append(bill)
    }
    
    // legislator delegate
    internal func getFavouriteLegislators() -> [LegislatorModel] {
        return self.legislatorFavourites
    }

    internal func isLiked(bioguide_id: String) -> Bool {
        if (self.legislatorFavourites.count == 0) {
            return false
        }
        for index in (0 ... self.legislatorFavourites.count - 1) {
            if (self.legislatorFavourites[index].bioguide_id == bioguide_id) {
                    return true
            }
        }
        return false
    }

    internal func unlikeLegislator(legislator: LegislatorModel) {
        for index in (0 ... self.legislatorFavourites.count - 1) {
            if (self.legislatorFavourites[index].bioguide_id == legislator.bioguide_id) {
                self.legislatorFavourites.remove(at: index)
                break
            }
        }
//        print("success unlike")
//        print(self.legislatorFavourites.count)
    }

    internal func likeLegislator(legislator: LegislatorModel) {
        self.legislatorFavourites.append(legislator)
//        print("success like")
//        print(self.legislatorFavourites.count)
    }

    
    var openMenu = false
    let screenSize: CGRect = UIScreen.main.bounds
    let menuPopup = MenuView()
    var categoryName = String()
    var legislatorFavourites : [LegislatorModel] = []
    var billFavourites : [BillModel] = []
    var committeeFavourites : [CommitteeModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor=UIColor.white
        
        
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(test))
        updateLeftBarButton()
        loadLegislators()
    }
    
    func updateLeftBarButton(){
        let menuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        menuBtn.addTarget(self, action: #selector(MainTabBarController.test), for: .touchUpInside)
        menuBtn.setImage(UIImage(named: "menu"), for: .normal)
        let rightButton = UIBarButtonItem(customView: menuBtn)
        self.navigationItem.setLeftBarButtonItems([rightButton], animated: true)
    }
    
    func loadLegislators() -> Void {
        let stateVC = LegislatorStateTableViewController()
        stateVC.delegate = self
        let houseVC = LegislatorHouseTableViewController()
        houseVC.delegate = self
        let senateVC = LegislatorSenateTableViewController()
        senateVC.delegate = self
        stateVC.title = "State"
        houseVC.title = "House"
        senateVC.title = "Senate"
        let controllers = [stateVC, houseVC, senateVC]
        self.viewControllers = controllers
    }
    
    func loadBills() -> Void {
        let activeVC = BillActiveTableViewController()
        activeVC.delegate = self
        let newVC = BillNewTableViewController()
        newVC.delegate = self
        activeVC.title = "Active"
        newVC.title = "New"
        let controllers = [activeVC, newVC]
        self.viewControllers = controllers
    }
    
    func loadCommittee() -> Void {
        let houseVC = CommitteeHouseTableViewController()
        houseVC.delegate = self
        let senateVC = CommitteeSenateTableViewController()
        senateVC.delegate = self
        let jointVC = CommitteeJointTableViewController()
        jointVC.delegate = self
        houseVC.title = "House"
        senateVC.title = "Senate"
        jointVC.title = "Joint"
        let controllers = [houseVC, senateVC, jointVC]
        self.viewControllers = controllers
    }
    
    func loadFavorite() -> Void {
        let legislatorVC = FavoriteLegislatorTableViewController()
        legislatorVC.delegate = self
        let billVC = FavoriteBillTableViewController()
        billVC.delegate = self
        let committeeVC = FavoriteCommitteeTableViewController()
        committeeVC.delegate = self
        legislatorVC.title = "Legislators"
        billVC.title = "Bills"
        committeeVC.title = "Committees"
        let controllers = [legislatorVC, billVC, committeeVC]
        self.viewControllers = controllers
    }
    
    func loadAbout() -> Void {
        let aboutVC = AboutViewController()
        let controllers = [aboutVC]
        self.viewControllers = controllers
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func test() -> Void {
        menuPopup.delegate = self
        UIApplication.shared.keyWindow?.addSubview(menuPopup)
    }
    
    func didSelectItemAtIndex(button: UIButton) {
        categoryName = String(button.tag)
        switch button.tag {
        case 0:
            loadLegislators()
            break
        case 1:
            loadBills()
            break
        case 2:
            loadCommittee()
            break
        case 3:
            loadFavorite()
            break
        case 4:
            loadAbout()
            break
        default:
            break
        }
//        print(categoryName)
        self.tabBarController?.selectedIndex = 0
//        loadLegislators()
//        viewDidLoad()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(viewController)
        return true
    }
    
    
    // FavouriteDataChangeProtocol
    

}
