//
//  MainTabBarController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/16/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, MenuItemDelegate, UITabBarControllerDelegate {
    
    var openMenu = false
    let screenSize: CGRect = UIScreen.main.bounds
    let menuPopup = MenuView()
    var categoryName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        navigationItem.title = categoryName
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        
        self.navigationController?.navigationBar.barTintColor=UIColor.white
//        print(navigationItem)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(test))
//        self.navigationController?.navigationBar.backgroundColor = UIColor.blue
    }
    
    func loadLegislators() -> Void {
        let stateVC = LegislatorStateTableViewController()
        let controllers = [stateVC]
        self.viewControllers = controllers
    }
    
    func loadBills() -> Void {
        let activeVC = BillActiveTableViewController()
        let controllers = [activeVC]
        self.viewControllers = controllers
    }
    
    func loadCommittee() -> Void {
        let houseVC = CommitteeHouseTableViewController()
        let controllers = [houseVC]
        self.viewControllers = controllers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = categoryName
        print(categoryName)


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
        default:
            break
        }
        print(categoryName)
//        loadLegislators()
//        viewDidLoad()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(viewController)
        return true
    }

}
