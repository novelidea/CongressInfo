//
//  CommitteeTableViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class CommitteeHouseTableViewController: UITableViewController {

    var committees : [CommitteeModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        navigationController?.navigationBar.topItem?.title = "Committee"
//        self.tableView.rowHeight = 120
        downloadData()
    }
    
    func downloadData() -> Void {
        let requestURL: NSURL = NSURL(string: baseURLStr + "f=committeeshouse")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:AnyObject]
//                    print(json)
                    if let results = json["results"] as? [[String: AnyObject]] {
//                        print(results)
                        for committee in results {
                            let model = CommitteeModel.initCommitteeWithDict(data: committee)
                            self.committees.append(model)
                        }
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.committees.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.committees[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CommitteeHouseTableCell")
        cell.textLabel?.text = model.committee_name
        cell.detailTextLabel?.text = model.committee_id
        return cell
    }
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = CommitteeDetailViewController()
        detailVC.committeeDetail = self.committees[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }


}
