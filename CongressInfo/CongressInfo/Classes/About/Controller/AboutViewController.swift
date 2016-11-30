//
//  AboutViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "About"
        self.tabBarController?.tabBar.isHidden = true
        addChildView()
        // Do any additional setup after loading the view.
    }
    
    func addChildView() -> Void {
        let profile = UIImage(named: "profile");
        let profileView = UIImageView(image: profile);
        profileView.frame = CGRect(x: 40, y: 90, width: screenWidth - 2 * 40, height: screenHeight * 0.4)
        self.view.addSubview(profileView)
        
        let infoLabel = UILabel(frame: CGRect(x: 30, y: screenHeight * 0.55, width: screenWidth - 2 * 30, height: 40))
        infoLabel.text = "1847824832"
        infoLabel.textAlignment = .center
        self.view.addSubview(infoLabel)
        
        let nameLabel = UILabel(frame: CGRect(x: 30, y: screenHeight * 0.65, width: screenWidth - 2 * 30, height: 40))
        nameLabel.text = "Pengfei Xing"
        nameLabel.textAlignment = .center
        self.view.addSubview(nameLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
