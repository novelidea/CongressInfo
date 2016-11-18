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
    
    class func initLegislatorWithDict(data: [String: AnyObject]) -> LegislatorModel {
        let instance = LegislatorModel()
        if let bioguide_id = data["bioguide_id"] as? String {
            instance.bioguide_id = bioguide_id
        }
        if let chamber = data["chamber"] as? String {
            instance.chamber = chamber
        }
        
        return instance
    }
    
}
