//
//  LegislatorSenateTableViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire

class LegislatorSenateTableViewController: UITableViewController, UISearchBarDelegate {

    var legislators : [LegislatorModel] = []
    var delegate : FavouriteDataChangeProtocol!
    
    var legislators_backup : [LegislatorModel] = []
    var didClickSearch = false
    let searchBar = UISearchBar()
    let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Legislator"
        downloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        SwiftSpinner.show("Fetching Data...")
        downloadData()
    }
    
    func downloadData() -> Void {
        Alamofire.request(baseURLStr + "f=legislatorssenate").responseJSON { response in
            
            if let data = response.data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String:AnyObject]
                    if let results = json["results"] as? [[String: AnyObject]] {
                        //                        print(results)
                        for legislator in results {
                            let model = LegislatorModel.initLegislatorWithDict(data: legislator)
                            self.legislators.append(model)
                            self.legislators_backup.append(model)
                        }
                        self.legislators.sort { $0.last_name.compare($1.last_name) == .orderedAscending }
                        self.legislators.sort { $0.last_name.compare($1.last_name) == .orderedAscending }
                        SwiftSpinner.hide()
                        self.tableView.reloadData()
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
    }
    
    func downloadData2() -> Void {
        let requestURL: NSURL = NSURL(string: baseURLStr + "f=legislatorssenate")!
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
                        for legislator in results {
                            let model = LegislatorModel.initLegislatorWithDict(data: legislator)
                            self.legislators.append(model)
                            self.legislators_backup.append(model)
                        }
                        self.legislators.sort { $0.last_name.compare($1.last_name) == .orderedAscending }
                        self.legislators.sort { $0.last_name.compare($1.last_name) == .orderedAscending }
                        SwiftSpinner.hide()
                    }
                }catch {
                    print("Error with Json: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        task.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateRighBarButton()
    }
    
    func updateRighBarButton(){
        searchBtn.addTarget(self, action: #selector(LegislatorStateTableViewController.filterClicked), for: .touchUpInside)
        searchBtn.setImage(UIImage(named: "search"), for: .normal)
        
        let rightButton = UIBarButtonItem(customView: searchBtn)
        self.parent?.navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }
    
    func filterClicked() -> Void {
        if (didClickSearch == false) {
            didClickSearch = true
            createSearch()
            searchBtn.setImage(UIImage(named: "cancel"), for: .normal)
            let rightButton = UIBarButtonItem(customView: searchBtn)
            self.parent?.navigationItem.setRightBarButtonItems([rightButton], animated: true)
            
        } else {
            didClickSearch = false
            removeSearch()
            searchBtn.setImage(UIImage(named: "search"), for: .normal)
            let rightButton = UIBarButtonItem(customView: searchBtn)
            self.parent?.navigationItem.setRightBarButtonItems([rightButton], animated: true)
        }
        
    }
    func removeSearch() -> Void {
        self.parent?.navigationItem.titleView = nil
        self.parent?.navigationItem.title = "Legislator"
    }
    
    func createSearch() -> Void {
        searchBar.showsCancelButton = false
        searchBar.placeholder = "search"
        searchBar.delegate = self
        
        self.parent?.navigationItem.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        print(searchText)
        if (searchText.characters.count == 0) {
            self.legislators = self.legislators_backup
        } else {
            var tmp : [LegislatorModel] = []
            for index in 1 ... self.legislators_backup.count - 1 {
                let model = self.legislators_backup[index]
                if (model.name.lowercased().contains(searchText.lowercased())) {
                    tmp.append(model)
                }
            }
            self.legislators = tmp
        }
        self.tableView.reloadData()
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = LegislatorDetailViewController()
        detailVC.legislatorDetail = self.legislators[indexPath.row]
        detailVC.delegate = self.delegate
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
