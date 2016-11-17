//
//  MainTabBarController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/16/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var openMenu = false
    let screenSize: CGRect = UIScreen.main.bounds
    let menuPopup = MenuView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        navigationItem.title = "Legislator"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        
        self.navigationController?.navigationBar.barTintColor=UIColor.white
        print(navigationItem)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(test))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func test() -> Void {
        UIApplication.shared.keyWindow?.addSubview(menuPopup)
    }

}
