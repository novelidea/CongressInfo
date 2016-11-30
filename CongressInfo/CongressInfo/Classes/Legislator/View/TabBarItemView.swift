//
//  TabBarItemView.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/29/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class TabBarItemView: UITabBarItem {
    var name = String()
    class func initTabBarItemWithName(name : String) -> UITabBarItem {
        let item = TabBarItemView()
        let nameLabel = UILabel(frame: CGRect(x: 5, y: 20, width: 150, height: 150))
        nameLabel.text = name
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        let image = item.labelToImage(label: nameLabel)
        
        item.image = image
        
        return item
    }
    
    override init() {
        super.init()
    }
    
    func labelToImage(label : UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
