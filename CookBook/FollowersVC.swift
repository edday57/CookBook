//
//  FollowersVC.swift
//  CookBook
//
//  Created by Edward Day on 05/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit

import Parse

var show_ = String()
var user = String()

class FollowersVC: UITableViewController {
    
    //arrays
    let lightBlue = UIColor(colorLiteralRed: 88/255, green: 190/255, blue: 239/255, alpha: 1)
    let lightGreen = UIColor(colorLiteralRed: 139/255, green: 241/255, blue: 111/255, alpha: 1)
    var fullnameArray = [String]()
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    
    //shows who we follow or is following us
    var followArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        
        //set tile
        self.navigationItem.title = show_
        
        
        //load followers if user tapped followers
        if show_ == "Followers" {
            loadfollowers()
        }
        //load following is user tapped following
        if show_ == "Following" {
            loadfollowing()
        }
        

          }

    //find users followers
    func loadfollowers() {
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                //clean up
                self.followArray.removeAll(keepingCapacity: false)
                
                //find related objects and add to array
                for object in objects! {
                    self.followArray.append(object.value(forKey: "follower") as! String)
                }
                
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.followArray)
                query?.addDescendingOrder("createdAt")
                query?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                    if error == nil {
                        self.fullnameArray.removeAll(keepingCapacity: false)
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.avaArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            self.fullnameArray.append((object.object(forKey: "fullname")as! String).capitalized)
                            self.usernameArray.append(object.object(forKey: "username")as! String)
                            self.avaArray.append(object.object(forKey: "ava")as! PFFile)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
                
            }
        }
        
    }
    //find users following
    func loadfollowing() {
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: user)
        followQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                self.followArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.followArray.append(object.value(forKey: "following")as! String)
                }
                
                //find users followed by user
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.followArray)
                query?.addDescendingOrder("createdAt")
                query?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                    if error == nil {
                        self.fullnameArray.removeAll(keepingCapacity: false)
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.avaArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            self.fullnameArray.append((object.object(forKey: "fullname")as! String).capitalized)
                            self.usernameArray.append(object.object(forKey: "username")as! String)
                            self.avaArray.append(object.object(forKey: "ava")as! PFFile)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            } else {
                print(error!.localizedDescription)
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return usernameArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FollowersCell
        
        //connect server data to cell
        cell.usernameLbl.text = usernameArray[indexPath.row]
        cell.fullnameLbl.text = fullnameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        //Check if user is following user on list to determine button text
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: PFUser.current()!.username!)
        query.whereKey("following", equalTo: cell.usernameLbl.text!)
        query.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                if count == 0 {
                    cell.followBtn.setTitle("", for: UIControlState.normal)
                    cell.followBg.layer.backgroundColor = UIColor.lightGray.cgColor
                    cell.followBg.layer.cornerRadius = 5
                    cell.followBg.layer.masksToBounds = true
                    

                    
                } else {
                    cell.followBtn.setTitle("", for: UIControlState.normal)
                    cell.followBg.layer.cornerRadius = 5
                    cell.followBg.layer.masksToBounds = true
                    cell.followBg.layer.backgroundColor = self.lightGreen.cgColor

                }
            }
        }
        
        //Hide follow button for youself (if you look on your friend and they are following you!)
        if cell.usernameLbl.text == PFUser.current()?.username {
            cell.followBtn.isHidden = true
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FollowersCell
        
        //if select self then go home, otherwise go to guest
        if cell.usernameLbl.text! == PFUser.current()!.username! {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as! NewProfileVC
            self.navigationController?.pushViewController(home, animated: true)
            
        } else {
            guestname.append(cell.usernameLbl.text!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! NewGuestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
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
