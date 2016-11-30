//
//  LegislatorStateTableViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit
import Alamofire
//import NVActivityIndicatorView
import SwiftSpinner

class LegislatorStateTableViewController: UITableViewController, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Dictionary Section
    var dataDict = [String : [LegislatorModel]]()
    var dataDict_backup = [String : [LegislatorModel]]()
    
    var indexArray : [String] = []
    var indexArray_backup : [String] = []

//    let activityIndicatorView = NVActivityIndicatorView
    let pickerData : [String] =  usStates
    var legislators : [LegislatorModel] = []
    
    var legislators_backup : [LegislatorModel] = []
    var didClickSearch = false
//    let searchBar = UISearchBar()
//    let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    var delegate : FavouriteDataChangeProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = false
        self.parent?.navigationItem.title = "Legislator"
//        navigationController?.navigationBar.topItem?.title = "Legislator"
//        downloadData()
        updateRighBarButton()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.isHidden = true
        self.parent?.view.addSubview(self.pickerView)
        
        self.pickerView.backgroundColor = UIColor.white
//        createSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.legislators_backup.count == 0) {
            SwiftSpinner.show("Fetching Data...")
            downloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateRighBarButton()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return screenWidth
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
//        label.backgroundColor = UIColor.blue
        label.text = self.pickerData[row]
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(pickerData[row])
        self.pickerView.isHidden = true
        self.tableView.isScrollEnabled = true
        if (pickerData[row] == "All States") {
            self.legislators = self.legislators_backup
        } else {
            var tmp : [LegislatorModel] = []
            for index in 0 ... self.legislators_backup.count - 1 {
                let model = self.legislators_backup[index]
                if (model.state == pickerData[row]) {
                    tmp.append(model)
                }
            }
            self.legislators = tmp
        }
        self.tableView.reloadData()
    }
    
    func updateRighBarButton(){
        let filterBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        filterBtn.addTarget(self, action: #selector(LegislatorStateTableViewController.filterClicked), for: .touchUpInside)
        
//        filterBtn.setImage(UIImage(named: "liked"), for: .normal)
        filterBtn.setTitle("Filter", for: .normal)
        filterBtn.setTitleColor(UIColor.blue, for: .normal)
        
        let rightButton = UIBarButtonItem(customView: filterBtn)
        self.parent?.navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }
    
    func filterClicked() -> Void {
//        createSearch()
//        createPickerView()
        self.pickerView.isHidden = false
        self.tableView.isScrollEnabled = false
    }
    
    func createPickerView() -> Void {
//        self.pickerView.backgroundColor = UIColor.red
        self.view.addSubview(self.pickerView)
    }
    
    func createSearch() -> Void {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "search"
        searchBar.delegate = self
        
        self.parent?.navigationItem.titleView = searchBar
    }
    
    func downloadData() -> Void {
        if (self.legislators_backup.count > 0) {
            SwiftSpinner.hide()
            return
        }
        Alamofire.request(baseURLStr + "f=legislators").responseJSON { response in
            
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
                            
                            
                            //                            }
//                            print(letters[0])
                        }
                        self.legislators.sort { $0.state.compare($1.state) == .orderedAscending }
                        self.legislators_backup.sort { $0.state.compare($1.state) == .orderedAscending }
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
    
//    func downloadData2() -> Void {
//        
//        
//        
//        let requestURL: NSURL = NSURL(string: baseURLStr + "f=legislatorshouse")!
//        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
//        let session = URLSession.shared
//        let task = session.dataTask(with: urlRequest as URLRequest) {
//            (data, response, error) -> Void in
//            
//            let httpResponse = response as! HTTPURLResponse
//            let statusCode = httpResponse.statusCode
//            
//            if (statusCode == 200) {
//                print("Everyone is fine, file downloaded successfully.")
//                do{
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:AnyObject]
//                    if let results = json["results"] as? [[String: AnyObject]] {
//                        print(results)
//                        for legislator in results {
//                            let model = LegislatorModel.initLegislatorWithDict(data: legislator)
//                            
//
//                            self.legislators.append(model)
//                            self.legislators_backup.append(model)
//                        }
//                        self.legislators.sort { $0.state.compare($1.state) == .orderedAscending }
//                        self.legislators_backup.sort { $0.state.compare($1.state) == .orderedAscending }
////                        SwiftSpinner.hide()
//                        SwiftSpinner.hide()
//                        self.tableView.reloadData()
//                    }
//                    
//                }catch {
//                    print("Error with Json: \(error)")
//                }
//            }
//            
//        }
//        
//        task.resume()
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        return self.legislators.count == 0 ? 0 : 1
//        return 1
        print("section number is: ")
        print(self.indexArray.count)
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
