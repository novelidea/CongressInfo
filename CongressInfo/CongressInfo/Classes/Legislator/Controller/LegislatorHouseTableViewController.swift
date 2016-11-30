//
//  LegislatorHouseTableViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire

class LegislatorHouseTableViewController: UITableViewController, UISearchBarDelegate {

    var legislators : [LegislatorModel] = []
    var legislators_backup : [LegislatorModel] = []
    var delegate : FavouriteDataChangeProtocol!
    
    // Dictionary Section
    var dataDict = [String : [LegislatorModel]]()
    var dataDict_backup = [String : [LegislatorModel]]()
    
    var indexArray : [String] = []
    var indexArray_backup : [String] = []
    
    var didClickSearch = false
    let searchBar = UISearchBar()
    let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Legislator"
//        downloadData()
        
        updateRighBarButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateRighBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        SwiftSpinner.show("Fetching Data...")
//        downloadData()
        if (self.legislators_backup.count == 0) {
            SwiftSpinner.show("Fetching Data...")
            downloadData()
        }
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
        if (searchText.characters.count == 0) {
            self.indexArray = self.indexArray_backup
            self.dataDict = self.dataDict_backup
            self.legislators = self.legislators_backup
        } else {
            var tmp : [LegislatorModel] = []
            for index in 1 ... self.legislators_backup.count - 1 {
                let model = self.legislators_backup[index]
                if (model.name.lowercased().contains(searchText.lowercased())) {
                    tmp.append(model)
                }
            }
            self.dataDict = [:]
            self.indexArray = []
            for model in tmp {
                    let state = model.state
                    let letters = state.characters.map { String($0) }
                    let key = letters[0]
                
                    if (self.dataDict[key] == nil) {
                        self.indexArray.append(key)
                        var valueArray : [LegislatorModel] = []
                        valueArray.append(model)
                        self.dataDict[key] = valueArray
                    } else {
                        var valueArray : [LegislatorModel] = self.dataDict[key]!
                        valueArray.append(model)
                        self.dataDict[key] = valueArray
                    }
            }
            self.indexArray.sort { $0.compare($1) == .orderedAscending}
            if (self.indexArray.count > 0) {
                for i in 0 ... self.indexArray.count - 1 {
                    let key = self.indexArray[i]
                    self.dataDict[key]?.sort { $0.state.compare($1.state) == .orderedAscending }
                }
            }
        }
        self.tableView.reloadData()
    }

    func downloadData() -> Void {
        if (self.legislators_backup.count > 0) {
            SwiftSpinner.hide()
            return
        }
        Alamofire.request(baseURLStr + "f=legislatorshouse").responseJSON { response in
            
            if let data = response.data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String:AnyObject]
                    if let results = json["results"] as? [[String: AnyObject]] {
                        //                        print(results)
                        for legislator in results {
                            let model = LegislatorModel.initLegislatorWithDict(data: legislator)
                            self.legislators.append(model)
                            self.legislators_backup.append(model)
                            
                            if (self.indexArray_backup.count == 0) {
                                let state = model.state
                                let letters = state.characters.map { String($0) }
                                let key = letters[0]
                                //                            if (self.indexArray.count == 0) {
                                
                                
                                if (self.dataDict[key] == nil) {
                                    self.indexArray.append(key)
                                    var valueArray : [LegislatorModel] = []
                                    valueArray.append(model)
                                    self.dataDict[key] = valueArray
                                } else {
                                    var valueArray : [LegislatorModel] = self.dataDict[key]!
                                    valueArray.append(model)
                                    self.dataDict[key] = valueArray
                                }
                            }
                        }
                        self.legislators.sort { $0.last_name.compare($1.last_name) == .orderedAscending }
                        self.legislators.sort { $0.last_name.compare($1.last_name) == .orderedAscending }
                        
                        if (self.indexArray_backup.count == 0) {
                            self.indexArray.sort { $0.compare($1) == .orderedAscending}
                            self.indexArray_backup = self.indexArray
                            if (self.indexArray.count > 0) {
                                for i in 0 ... self.indexArray.count - 1 {
                                    let key = self.indexArray[i]
                                    self.dataDict[key]?.sort { $0.state.compare($1.state) == .orderedAscending }
                                }
                            }
                            self.dataDict_backup = self.dataDict
                        } else {
                            self.dataDict = self.dataDict_backup
                            self.indexArray = self.indexArray_backup
                        }

                        
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
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:AnyObject]
//                    self.legislators = []
//                    self.legislators_backup = []
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //        return self.legislators.count == 0 ? 0 : 1
//        return 1
        return self.indexArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print(self.legislators.count)
//        return self.legislators.count
        let key = self.indexArray[section]
        return (self.dataDict[key]?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//        let model = self.legislators[indexPath.row]
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "legislatorsState")
//        cell.textLabel?.text = model.name
//        cell.detailTextLabel?.text = model.state
//        
//        let url = URL(string: legislatorThumbailURLStrBase + model.bioguide_id + ".jpg")
//        
//        DispatchQueue.global().async {
//            if let data = try? Data(contentsOf: url!) {
//                DispatchQueue.main.async {
//                    cell.imageView?.image = UIImage(data: data)
//                    model.profile = data
//                }
//            }
//            
//        }
//        return cell
        let key = self.indexArray[indexPath.section]
        let array = self.dataDict[key]
        let model : LegislatorModel = (array?[indexPath.row])!
//        let model = self.legislators[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "legislatorsState")
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = model.state
        
        let url = URL(string: legislatorThumbailURLStrBase + model.bioguide_id + ".jpg")
        
        
        if (model.profile.count == 0) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                        model.profile = data
                        cell.layoutSubviews()
                    }
                }
            }
        } else {
            cell.imageView?.image = UIImage(data: model.profile)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.indexArray[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = LegislatorDetailViewController()
        detailVC.legislatorDetail = self.legislators[indexPath.row]
        detailVC.delegate = self.delegate
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
