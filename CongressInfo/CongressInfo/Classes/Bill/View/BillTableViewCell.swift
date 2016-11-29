//
//  BillTableViewCell.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/29/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {

    var bill_id = String()
    var bill_title = String()
    var introduced_on = String()
    
    class func initCellWithValue(bill_id : String, bill_title : String, introduced_on : String) -> BillTableViewCell {
        let cell = BillTableViewCell(style: .default, reuseIdentifier: "BillDetailCell")
        cell.bill_id = bill_id
        cell.bill_title = bill_title
        cell.introduced_on = introduced_on
        
        cell.addChildView()
        return cell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addChildView() -> Void {
        let billIDLabel = UILabel()
        billIDLabel.text = bill_id
        billIDLabel.font = UIFont.boldSystemFont(ofSize: 15)
        billIDLabel.frame = CGRect(x: 10, y: 10, width: self.frame.width, height: 20)
        self.addSubview(billIDLabel)
        
        let billTitleLabel = UILabel()
        billTitleLabel.text = bill_title
        let title_y = billIDLabel.frame.maxY
        billTitleLabel.frame = CGRect(x: 10, y: title_y + 5, width: self.frame.width, height: 20)
        billTitleLabel.numberOfLines = 3
        billTitleLabel.sizeToFit()
        self.addSubview(billTitleLabel)
        
        let introducedOnLabel = UILabel();
        
//        let formatter = DateFormatter()
//        formatter.dateStyle = DateFormatter.Style.medium
//        formatter.timeStyle = .medium
//        
//        let dateString = formatter.string(from: introduced_on)
        introducedOnLabel.text = introduced_on
        let date_y = billTitleLabel.frame.maxY
        introducedOnLabel.frame = CGRect(x: 10, y: date_y + 5, width: self.frame.width, height: 20)
        self.addSubview(introducedOnLabel)
    }
}
