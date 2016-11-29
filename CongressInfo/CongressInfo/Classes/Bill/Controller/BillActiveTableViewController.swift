//
//  BillsTableViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class BillActiveTableViewController: UITableViewController, UISearchBarDelegate {
    
    var bills : [BillModel] = []
    var delegate : FavouriteDataChangeProtocol!
    
    var bills_backup : [BillModel] = []

    var didClickSearch = false
    let searchBar = UISearchBar()
    let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Bill"
        self.tableView.rowHeight = 130
        downloadData()
        updateRighBarButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateRighBarButton()
    }
    
    func updateRighBarButton(){
        searchBtn.addTarget(self, action: #selector(BillActiveTableViewController.filterClicked), for: .touchUpInside)
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
            self.bills = self.bills_backup
        } else {
            var tmp : [BillModel] = []
            for index in 1 ... self.bills_backup.count - 1 {
                let model = self.bills_backup[index]
                if (model.title.lowercased().contains(searchText.lowercased())) {
                    tmp.append(model)
                }
            }
            self.bills = tmp
        }
        self.tableView.reloadData()
    }

    
    func downloadData() -> Void {
        let requestURL: NSURL = NSURL(string: baseURLStr + "f=billsactive")!
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
                            self.bills_backup.append(model)
                        }
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-DD"
//            let origin = dateFormatter.date(from: introduced_on)
            print(self.bills[0].introduced_on)
//            self.bills.sort(by: {dateFormatter.date(from:$0.introduced_on)?.timeIntervalSince1970 < dateFormatter.date(from:$1.introduced_on).timeIntervalSince1970})
            
            self.bills.sort { dateFormatter.date(from:$0.introduced_on)?.compare(dateFormatter.date(from:($1.introduced_on))!) == .orderedDescending }
            
//            self.bills.sort { $0.introduced_on.compare($1.introduced_on) == .orderedDescending }
            print(self.bills[0].introduced_on)
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
        return self.bills.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.bills[indexPath.row]
        let cell = BillTableViewCell.initCellWithValue(bill_id: model.bill_id, bill_title: model.title, introduced_on: model.introduced_on)
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-DD"
//        let origin = dateFormatter.date(from: model.introduced_on)
//        
//        dateFormatter.dateStyle = DateFormatter.Style.medium
//        let convertedDate = dateFormatter.string(from: origin! as Date)
//        
//        print(convertedDate)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = BillDetailViewController()
        detailVC.billDetail = self.bills[indexPath.row]
        detailVC.delegate = self.delegate
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
