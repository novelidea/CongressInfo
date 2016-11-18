//
//  LegislatorStateTableViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit
import Alamofire

class LegislatorStateTableViewController: UITableViewController {

    var legislators = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.brown
        
        navigationController?.navigationBar.topItem?.title = "Legislator"
        downloadData()
    }
    
    func downloadData() -> Void {
//        baseURLStr + "f=legislatorshouse"
//        Alamofire.request("http://www.learnswiftonline.com/Samples/subway.json").validate().responseJSON { response in
//            switch response.result {
//            case .success:
//                print(response)
////                let data = response["result"] as! NSArray
//                
////                self.tableView.reloadData()
////                print("Validation Successful")
//            case .failure(let error):
//                print(response)
//                print(error)
//            }
//        }
//        let requestURL: NSURL = NSURL(string: "http://www.learnswiftonline.com/Samples/subway.json")!
        let requestURL: NSURL = NSURL(string: baseURLStr + "f=legislatorshouse")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                do{
                    
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:AnyObject]

//                    print(json)
                    if let results = json["results"] as? [[String: AnyObject]] {
//                        if let results = stations["results"] as? [[String: AnyObject]] {
//                            print(stations)
//                        }
                        for legislator in results {
//                            print(station)
                            print("=========================================================")
                            let model = LegislatorModel.initLegislatorWithDict(data: legislator)
                            print(model.bioguide_id)
//                            if let name = legislator["bioguide_id"] as? String {
//                                
//                                if let year = legislator["first_name"] as? String {
//                                    print(name,year)
//                                }
//                                
//                            }
                        }
                        
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
