//
//  LegislatorDetailViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/18/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class LegislatorDetailViewController: UIViewController {
    
    var legislatorDetail = LegislatorModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        addChildView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addChildView() -> Void {
        let profile = UIImage(data: self.legislatorDetail.profile)
        let profileView = UIImageView(image: profile)
        profileView.frame = CGRect(x: screenWidth * 0.3, y: 90, width: screenWidth * 0.4, height: screenHeight * 0.25)
        self.view.addSubview(profileView)
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
