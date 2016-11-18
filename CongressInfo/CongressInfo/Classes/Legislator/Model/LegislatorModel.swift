//
//  LegislatorModel.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class LegislatorModel: NSObject {
    var bioguide_id = String()
    var chamber = String()
    var first_name = String()
    var middle_name = String()
    var last_name = String()
    var name = String()
    var state = String()
    var birthday = String()
    class func initLegislatorWithDict(data: [String: AnyObject]) -> LegislatorModel {
        let instance = LegislatorModel()
        if let bioguide_id = data["bioguide_id"] as? String {
            instance.bioguide_id = bioguide_id
        }
        if let chamber = data["chamber"] as? String {
            instance.chamber = chamber
        }
        // name
        if let first_name = data["first_name"] as? String {
            instance.first_name = first_name
            instance.name = instance.name.appending(first_name + " ")
        }
        if let middle_name = data["middle_name"] as? String {
            instance.middle_name = middle_name
            instance.name = instance.name.appending(middle_name + " ")
        }
        if let last_name = data["last_name"] as? String {
            instance.last_name = last_name
            instance.name = instance.name.appending(last_name)
        }
        if let state = data["state_name"] as? String {
            instance.state = state
        }
        if let birthday = data["birthday"] as? String {
            instance.birthday = birthday
        }
        return instance
    }
    
    func printSelf() -> Void {
        print(self.bioguide_id, self.name, self.state, self.birthday)
    }
    
}