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

    var legislators : [LegislatorModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.brown
        
        navigationController?.navigationBar.topItem?.title = "Legislator"
        downloadData()
    }
    
    func downloadData() -> Void {
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
                            let model = LegislatorModel.initLegislatorWithDict(data: legislator)
                            self.legislators.append(model)
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
        // #warning Incomplete implementation, return the number of sections
//        return self.legislators.count == 0 ? 0 : 1
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(self.legislators.count)
        return self.legislators.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let model = self.legislators[indexPath.row] 
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "legislatorsState")
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = model.state
        
        let url = URL(string: legislatorThumbailURLStrBase + model.bioguide_id + ".jpg")

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data)
                    model.profile = data
                }
            }
            
        }
        
//        cell.imageView?.image = UIImage(data: model.profile)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = LegislatorDetailViewController()
        detailVC.legislatorDetail = self.legislators[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
 

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
