//
//  BillModel.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/18/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class BillModel: NSObject {
    var title = String()
    var bill_id = String()
    var bill_type = String()
    var sponsor = String()
    var last_action = String()
    var pdf = String()
    var chamber = String()
    var last_vote = String()
    var status = String()
    var introduced_on = String()
    class func initBillWithDict(data: [String: AnyObject]) -> BillModel {
        let instance = BillModel()
        if let title = data["official_title"] as? String {
            instance.title = title
        }
        if let bill_id = data["bill_id"] as? String {
            instance.bill_id = bill_id
        }
        if let bill_type = data["bill_type"] as? String {
            instance.bill_type = bill_type
        }
        if let sponsor = data["sponsor"] as? [String : AnyObject] {
            if let title = sponsor["title"] as? String {
                instance.sponsor = instance.sponsor + title + " "
            }
            if let first_name = sponsor["first_name"] as? String {
                instance.sponsor = instance.sponsor + first_name + " "
            }
            if let last_name = sponsor["last_name"] as? String {
                instance.sponsor = instance.sponsor + last_name
            }
        }
        if let last_action = data["last_action_at"] as? String {
            instance.last_action = last_action
        }
        if let last_version = data["last_version"] as? [String : AnyObject] {
//            print("==========================================")
//            print(last_version)
            if let urls = last_version["urls"] as? [String : AnyObject] {
//                print(urls)
                if let pdf = urls["pdf"] as? String {
                    instance.pdf = pdf
                }
            }
        }
        if let chamber = data["chamber"] as? String {
            instance.chamber = chamber
        }
        if let last_vote = data["last_vote_at"] as? String {
            instance.last_vote = last_vote
        }
        if let history = data["history"] as? [String : AnyObject] {
//            print(history)
//            print(history["active"] ?? "default")
            if let active = history["active"] as? Bool {
//                print(active)
                instance.status = (active == true ? "Active" : "New")
            }
        }
        if let introduced_on = data["introduced_on"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-DD"
            let origin = dateFormatter.date(from: introduced_on)
            
            dateFormatter.dateStyle = DateFormatter.Style.medium
            let convertedDate = dateFormatter.string(from: origin! as Date)
            instance.introduced_on = convertedDate
        }
        return instance
    }
    
    func printSelf() -> Void {
        
    }

}
