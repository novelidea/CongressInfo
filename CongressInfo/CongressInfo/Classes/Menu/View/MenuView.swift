//
//  MenuView.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/16/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class MenuView: UIView {
    let screenSize: CGRect = UIScreen.main.bounds

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height:screenSize.height))
//        self.backgroundColor = UIColor.blue
        self.isOpaque = true
        addChildren()
    }
    
    func addChildren() -> Void {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width * 0.6, height:screenSize.height))
        leftView.backgroundColor = UIColor.red
        
        let rightBtn = UIButton(frame: CGRect(x: screenSize.width * 0.6, y: 0, width: screenSize.width * 0.4, height:screenSize.height))
        rightBtn.addTarget(self, action: #selector(MenuView.removeSelf), for: .touchUpInside)
        rightBtn.isOpaque = true
        
        self.addSubview(leftView)
        self.addSubview(rightBtn)
    }
    
    func addMenuView() -> Void {
        
    }
    
    func removeSelf() -> Void {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
