//
//  CommitteeSenateTableViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit
import SwiftSpinner

class CommitteeSenateTableViewController: UITableViewController, UISearchBarDelegate {

    var committees : [CommitteeModel] = []
    var delegate : FavouriteDataChangeProtocol!
    
    var committees_backup : [CommitteeModel] = []
    
    var didClickSearch = false
    let searchBar = UISearchBar()
    let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Committee"
        //        self.tableView.rowHeight = 120
        downloadData()
        updateRighBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftSpinner.show("Fetching Data...")
        downloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateRighBarButton()
    }
    
    func updateRighBarButton(){
        searchBtn.addTarget(self, action: #selector(CommitteeHouseTableViewController.filterClicked), for: .touchUpInside)
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
        self.parent?.navigationItem.title = "Committee"
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
            self.committees = self.committees_backup
        } else {
            var tmp : [CommitteeModel] = []
            for index in 1 ... self.committees_backup.count - 1 {
                let model = self.committees_backup[index]
                if (model.committee_name.lowercased().contains(searchText.lowercased())) {
                    tmp.append(model)
                }
            }
            self.committees = tmp
        }
        self.tableView.reloadData()
    }
    
    func downloadData() -> Void {
        let requestURL: NSURL = NSURL(string: baseURLStr + "f=committeessenate")!
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
//                                                print(results)
                        for committee in results {
                            let model = CommitteeModel.initCommitteeWithDict(data: committee)
                            self.committees.append(model)
                            self.committees_backup.append(model)
                        }
                        self.committees.sort { $0.committee_name.compare($1.committee_name) == .orderedAscending }
                        self.committees_backup.sort { $0.committee_name.compare($1.committee_name) == .orderedAscending }
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
        detailVC.delegate = self.delegate
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
