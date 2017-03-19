//
//  SearchVC.swift
//  CookBook
//
//  Created by Edward Day on 18/03/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit
import Parse

class SearchVC: UITableViewController, UISearchBarDelegate {

    //Search Bar
    var searchBar = UISearchBar()
    
    //Arrays to hold information
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var fullnameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.darkGray
        searchBar.frame.size.width = self.view.frame.size.width - 30
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        loadNewUsers()
        }

    //Find 20 newest users as default content
    func loadNewUsers() {
        let userQuery = PFUser.query()
        userQuery?.order(byDescending: "createdAt")
        userQuery?.limit = 20
        userQuery?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                for object in objects! {
                    self.usernameArray.append(object.value(forKey: "username")as! String)
                    self.avaArray.append(object.value(forKey: "ava")as! PFFile)
                    self.fullnameArray.append(object.value(forKey: "fullname")as! String)
                }
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let usernameCheck = PFUser.query()
        usernameCheck?.whereKey("username", equalTo: searchBar.text!)
        usernameCheck?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                self.fullnameArray.removeAll(keepingCapacity: false)
                self.usernameArray.removeAll(keepingCapacity: false)
                self.avaArray.removeAll(keepingCapacity: false)
                //If they typed a valid username then list that
                if objects!.isEmpty == false{
                    for object in objects! {
                        self.usernameArray.append(object.value(forKey: "username") as! String)
                        self.fullnameArray.append(object.value(forKey: "fullname")as! String)
                        self.avaArray.append(object.value(forKey: "ava")as! PFFile)
                        self.tableView.reloadData()
                    }
                }
                else {
                    print("hi")
                    let fullnameQuery = PFUser.query()
                    fullnameQuery?.whereKey("fullname", matchesRegex: "(?i)" + self.searchBar.text!)
                    fullnameQuery?.findObjectsInBackground(block: { (block:[PFObject]?, error:Error?) in
                        if error == nil {
                            for object in objects! {
                                self.usernameArray.append(object.value(forKey: "username") as! String)
                                self.fullnameArray.append(object.value(forKey: "fullname")as! String)
                                self.avaArray.append(object.value(forKey: "ava")as! PFFile)
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
                
            }
        })
        return true
    }
    
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.fullnameArray.removeAll(keepingCapacity: false)
        self.usernameArray.removeAll(keepingCapacity: false)
        self.avaArray.removeAll(keepingCapacity: false)
        self.tableView.reloadData()
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernameArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! FollowersCell
        cell.usernameLbl.text = usernameArray[indexPath.row].capitalized
        avaArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
                
            }
        }
        cell.fullnameLbl.text = fullnameArray[indexPath.row]
        
        return cell
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
