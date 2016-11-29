//
//  BillNewTableViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class BillNewTableViewController: UITableViewController {

    var bills : [BillModel] = []
    var delegate : FavouriteDataChangeProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Bill"
        self.tableView.rowHeight = 130
        downloadData()
    }
    
    func downloadData() -> Void {
        let requestURL: NSURL = NSURL(string: baseURLStr + "f=billsnew")!
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
                    if let results = json["results"] as? [[String: AnyObject]] {
                        //                        print(results)
                        for bill in results {
                            let model = BillModel.initBillWithDict(data: bill)
                            self.bills.append(model)
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
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        return 0
        //        print(self.legislators.count)
        return self.bills.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.bills[indexPath.row]
        let cell = BillTableViewCell.initCellWithValue(bill_id: model.bill_id, bill_title: model.title, introduced_on: model.introduced_on)
        return cell
    }
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = BillDetailViewController()
        detailVC.billDetail = self.bills[indexPath.row]
        detailVC.delegate = self.delegate
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
