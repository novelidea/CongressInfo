//
//  CommitteeModel.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/18/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class CommitteeModel: NSObject {
    var committee_id = String()
    var committee_name = String()
    var parent_committee = String()
    var chamber = String()
    var office = String()
    var phone = String()
    class func initCommitteeWithDict(data: [String: AnyObject]) -> CommitteeModel {
        let instance = CommitteeModel()
        if let committee_id = data["committee_id"] as? String {
            instance.committee_id = committee_id
        }
        if let committee_name = data["name"] as? String {
            instance.committee_name = committee_name
        }
        if let parent_committee = data["parent_committee_id"] as? String {
            instance.parent_committee = parent_committee
        }
        if let chamber = data["chamber"] as? String {
            instance.chamber = chamber
        }
        if let office = data["office"] as? String {
            instance.office = office
        }
        if let phone = data["phone"] as? String {
            instance.phone = phone
        }
        return instance
    }
    
    func printSelf() -> Void {
        
    }

}
