//
//  FeedVC.swift
//  CookBook
//
//  Created by Edward Day on 15/03/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit
import Parse

class FeedVC: UITableViewController {
    
    var feedRecipeArray: Array <FeedRecipe?>= []
    var followingArray = [String]()
    var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func loadItems() {
        self.loading = true
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.current()!.username)
        followQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                for object in objects! {
                    self.followingArray.append(object.value(forKey: "following")as! String)
                    
                }
                let postQuery = PFQuery(className: "posts")
                postQuery.whereKey("username", containedIn: self.followingArray)
                postQuery.order(byDescending: "createdAt")
                postQuery.limit = 5
                postQuery.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                    if error == nil {
                        if objects!.count > 0 {
                            //Clean up
                            self.feedRecipeArray.removeAll(keepingCapacity: false)
                            self.feedRecipeArray = [FeedRecipe?](repeatElement(nil, count: objects!.count))
                            var counter = 0
                            var counterLimit = objects!.count
                            for i in 0...objects!.count - 1{
                                let object:AnyObject = objects![i]
                                let feedUsername = object.value(forKey: "username") as! String
                                let feedImgData = object.value(forKey: "picture") as! PFFile
                                let feedUuid = object.value(forKey: "uuid") as! String
                                let feedRecipeName = object.value(forKey: "title") as! String
                                feedImgData.getDataInBackground(block: { (data:Data?, error:Error?) in
                                    if error == nil {
                                        let feedImg = UIImage(data: data!)
                                        let userQuery = PFUser.query()
                                        userQuery?.whereKey("username", equalTo: feedUsername)
                                        userQuery?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                                            if error == nil {
                                                for object in objects! {
                                                    let feedFullname = object.value(forKey: "fullname")as! String
                                                    let feedAvaData = object.value(forKey: "ava") as! PFFile
                                                    feedAvaData.getDataInBackground(block: { (data:Data?, error:Error?) in
                                                        if error == nil {
                                                            let feedAva = UIImage(data: data!)
                                                            let ratingQuery = PFQuery(className: "ratings")
                                                            ratingQuery.whereKey("postid", equalTo: feedUuid)
                                                            ratingQuery.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                                                                if error == nil {
                                                                    var reviewCount = 1
                                                                    var reviewTotal = 5
                                                                    for object in objects! {
                                                                        reviewCount += 1
                                                                        reviewTotal += object.value(forKey: "rating")as! Int
                                                                    }
                                                                    let feedRating: Int = reviewTotal / reviewCount
                                                                    let post = FeedRecipe(username: feedUsername, ava: feedAva, rating: feedRating, img: feedImg, fullname: feedFullname, uuid: feedUuid, recipeName: feedRecipeName)
                                                                    self.feedRecipeArray[i] = post
                                                                    counter += 1
                                                                    print(String(counter))
                                                                    if counter == counterLimit {
                                                                        self.tableView.reloadData()
                                                                        self.loading = false
                                                                    }
                                                                }else {
                                                                    print(error!.localizedDescription)
                                                                }
                                                            })
                                                        } else {
                                                            print(error!.localizedDescription)
                                                        }
                                                    })
                                                }
                                            } else {
                                                print(error!.localizedDescription)
                                            }
                                        })
                                    } else {
                                        print(error!.localizedDescription)
                                    }
                                })
                            }
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
    
    //Cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }

    //Number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedRecipeArray.count
    }
    
    //Content for cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        if feedRecipeArray[indexPath.row] != nil {
            cell.feedAva.image = feedRecipeArray[indexPath.row]!.ava!
            cell.feedFullname.text = feedRecipeArray[indexPath.row]!.fullname!
            cell.feedImg.image = feedRecipeArray[indexPath.row]!.img!
            cell.feedRating.rating = feedRecipeArray[indexPath.row]!.rating!
            cell.feedRecipeName.text = feedRecipeArray[indexPath.row]!.recipeName!
        }
        return cell
    }


}
