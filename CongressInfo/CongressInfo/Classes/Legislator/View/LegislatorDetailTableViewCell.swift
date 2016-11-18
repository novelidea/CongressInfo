//
//  LegislatorDetailTableViewCell.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/18/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class LegislatorDetailTableViewCell: UITableViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    var cellName = String()
    var cellValue = String()
    var cellLink = String()
    
    class func initCellWithValue(name : String, value : String) -> LegislatorDetailTableViewCell {
        let cell = LegislatorDetailTableViewCell(style: .default, reuseIdentifier: "LegislatorDetailTableCell")
        cell.cellName = name
        cell.cellValue = value
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
        let cellNameLabel = UILabel()
        cellNameLabel.text = cellName
        
        cellNameLabel.frame = CGRect(x: 10, y: 0, width: self.frame.width * 0.4, height: self.frame.height)
        self.addSubview(cellNameLabel)
        
        let cellValueLabel = UILabel()
        cellValueLabel.text = cellValue
        cellValueLabel.frame = CGRect(x: cellNameLabel.frame.width + 30, y: 0, width: self.frame.width * 0.5, height: self.frame.height)
        
        if (cellName == "Twitter" || cellName == "Website") {
            cellValueLabel.textColor = UIColor.blue
        }
        
        self.addSubview(cellValueLabel)
    }

}
