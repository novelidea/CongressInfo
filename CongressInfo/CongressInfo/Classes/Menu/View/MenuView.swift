//
//  MenuView.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/16/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

protocol MenuItemDelegate {
    func didSelectItemAtIndex(button: UIButton)
}

class MenuView: UIView {
    let screenSize: CGRect = UIScreen.main.bounds
    var leftView = UIView()
    var rightBtn = UIButton()
    let leftMenuTitleRatio : CGFloat = 0.3
    let leftMenuItemHeight : CGFloat = 40
    
    var delegate: MenuItemDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height:screenSize.height))
//        self.backgroundColor = UIColor.blue
        self.isOpaque = true
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width * 0.7, height:screenSize.height))
        rightBtn = UIButton(frame: CGRect(x: screenSize.width * 0.7, y: 0, width: screenSize.width * 0.3, height:screenSize.height))
        addChildren()
    }
    
    func addChildren() -> Void {
        
        leftView.backgroundColor = UIColor(colorLiteralRed: 229/255, green: 235/255, blue: 223/255, alpha: 1)
        
        rightBtn.addTarget(self, action: #selector(MenuView.removeSelf), for: .touchUpInside)
        rightBtn.backgroundColor = UIColor(colorLiteralRed: 127/255, green: 127/255, blue: 127/255, alpha: 0.7)
        rightBtn.isOpaque = true
        
        self.addSubview(leftView)
        self.addSubview(rightBtn)
        addMenuView(frame: leftView.frame)
    }
    
    func addMenuView(frame : CGRect) -> Void {
        addMenuTitle(frame: frame)
        addMenuList(frame: frame)
    }
    func addMenuTitle(frame: CGRect) -> Void {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height:frame.height * leftMenuTitleRatio))
        titleView.backgroundColor = UIColor(colorLiteralRed: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        leftView.addSubview(titleView)
    }
    func addMenuList(frame: CGRect) -> Void {
//        var menuTableView = UITableView()
        let menuList : [String] = ["   Legislators", "   Bills", "   Committee", "   Favorite", "   About"]
        for index in 0...4 {
            print(index)
            addMenuItem(name: menuList[index], index: CGFloat(index), frame: frame)
        }
    }
    func addMenuItem(name: String, index: CGFloat, frame: CGRect) -> Void {
        let frameTmp = CGRect(x: 0, y: frame.height * leftMenuTitleRatio + leftMenuItemHeight * index + 10 * (index + 1), width: screenSize.width * 0.7, height:leftMenuItemHeight)
        let itemBtn = UIButton(frame: frameTmp)

//        itemBtn.titleLabel?.text = name
//        itemBtn.titleLabel?.textColor = UIColor.black
//        itemBtn.titleLabel?.backgroundColor = UIColor.clear
        itemBtn.setTitle(name, for: .normal)
        itemBtn.setTitleColor(UIColor.white, for: .selected)
        itemBtn.setTitleColor(UIColor.gray, for: .normal)
        
        itemBtn.titleLabel?.textAlignment = .left
        itemBtn.contentHorizontalAlignment = .left
        itemBtn.tag = Int(index)
        itemBtn.addTarget(self, action:#selector(self.menuItemClicked(sender:)), for: .touchUpInside)
        itemBtn.titleLabel?.font = UIFont.italicSystemFont(ofSize: 17)
        leftView.addSubview(itemBtn)
    }
    
    func menuItemClicked(sender: UIButton) -> Void {
        self.delegate.didSelectItemAtIndex(button: sender)
//        switch sender.tag {
//        case 0:
//            print("Legislators")
//            break
//        case 1:
//            print("Bills")
//            break
//        case 2:
//            print("Committee")
//            break
//        case 3:
//            print("Favorite")
//            break
//        case 4:
//            print("About")
//            break
//        default:
//            break
//        }
    }
    
    func removeSelf() -> Void {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
