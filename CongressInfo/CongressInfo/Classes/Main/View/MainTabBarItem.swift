//
//  MainTabBarItem.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class MainTabBarItem: UITabBarItem {
    
    override init() {
        super.init()
    }
    func addChildren(title: String, frame: CGRect) -> Void {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.frame = frame
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
