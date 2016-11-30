//
//  FavoriteLegislatorTableViewController.swift
//  CongressInfo
//
//  Created by XingPengfei on 11/17/16.
//  Copyright © 2016 Pengfei Xing. All rights reserved.
//

import UIKit

class FavoriteLegislatorTableViewController: UITableViewController, UISearchBarDelegate{

    var delegate : FavouriteDataChangeProtocol!
    
    var legislators : [LegislatorModel] = []
    var legislators_backup : [LegislatorModel] = []
    var didClickSearch = false
    let searchBar = UISearchBar()
    let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Favorite"
        self.tabBarController?.tabBar.isHidden = false
        self.legislators = self.delegate.getFavouriteLegislators()
        updateRighBarButton()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.legislators = self.delegate.getFavouriteLegislators()
        self.legislators_backup = self.delegate.getFavouriteLegislators()
        self.tableView.reloadData()
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
        if (self.legislators_backup.count == 0) {
            return
        }
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.legislators.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.legislators[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "legislatorsState")
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = model.state
        cell.imageView?.image = UIImage(data: model.profile)
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = LegislatorDetailViewController()
        detailVC.legislatorDetail = self.legislators[indexPath.row]
        detailVC.delegate = self.delegate
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
