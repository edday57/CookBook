//
//  FeedVC.swift
//  CookBook
//
//  Created by Edward Day on 15/03/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit
import Parse

class FeedVC: UITableViewController, UIGestureRecognizerDelegate{
    
    var feedRecipeArray: Array <FeedRecipe?>= []
    var followingArray = [String]()
    var loading = false
    var postPerLoad = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        self.refreshControl?.addTarget(self, action: #selector(FeedVC.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        loadItems()

        //refreshControl.endRefreshing()
    }
    var loadedNumber = 0
    func loadItems() {
        self.loading = true
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.current()!.username)
        followQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                for object in objects! {
                    self.followingArray.append(object.value(forKey: "following")as! String)
                    
                }
                self.followingArray.append(PFUser.current()!.username!)
                let postQuery = PFQuery(className: "posts")
                postQuery.whereKey("username", containedIn: self.followingArray)
                postQuery.order(byDescending: "createdAt")
                postQuery.limit = self.postPerLoad
                postQuery.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                    if error == nil {
                        if objects?.count != 0 {
                        if objects!.count > 0 {
                            self.loadedNumber += objects!.count
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
                                                                    if self.refreshControl!.isRefreshing {
                                                                        self.refreshControl?.endRefreshing()
                                                                    }
                                                                    if counter == counterLimit {
                                                                        self.tableView.reloadData()
                                                                        if counter == self.postPerLoad {
                                                                            self.loading = false
                                                                        }
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
    

    func loadMore() {
        self.loading = true
        let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("username", containedIn: self.followingArray)
        postQuery.order(byDescending: "createdAt")
        postQuery.skip = loadedNumber
        postQuery.limit = self.postPerLoad
        postQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                if objects?.count != 0 {
                    if objects!.count > 0 {
                        self.loadedNumber += objects!.count
                        print("hi")
                        var morePostsArray: Array <FeedRecipe?> = []
                        morePostsArray = [FeedRecipe?](repeatElement(nil, count: objects!.count))
                        var counter = 0
                        let counterLimit = objects!.count
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
                                                                morePostsArray[i] = post
                                                                counter += 1
                                                                if counter == counterLimit {
                                                                    self.feedRecipeArray = self.feedRecipeArray + morePostsArray
                                                                    self.tableView.reloadData()
                                                                    if counter == self.postPerLoad {
                                                                        self.loading = false
                                                                    }
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
                                        } else {
                                            print(error!.localizedDescription)
                                        }
                                    })
                                }else {
                                    print(error!.localizedDescription)
                                }
                            })
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
        
    }
    }
    
    //Cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell")as! FeedCell
        
        let height = cell.feedImg.frame.height + 80 + 12
        return height
    }

    //Number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedRecipeArray.count
    }
    
    //Content for cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var nameTap = UITapGestureRecognizer(target: self, action: #selector(FeedVC.nameTapped(_:)))
        nameTap.delegate = self
        nameTap.numberOfTapsRequired = 1
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        cell.feedFullname.addGestureRecognizer(nameTap)
        cell.isUserInteractionEnabled = true
        cell.infoView.isUserInteractionEnabled = true
        if feedRecipeArray[indexPath.row] != nil {
            cell.feedAva.image = feedRecipeArray[indexPath.row]!.ava!
            cell.feedFullname.text = "By \((feedRecipeArray[indexPath.row]!.fullname!).capitalized)"
            cell.feedImg.image = feedRecipeArray[indexPath.row]!.img!
            cell.feedRating.rating = feedRecipeArray[indexPath.row]!.rating!
            cell.feedRecipeName.text = feedRecipeArray[indexPath.row]!.recipeName!
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postuuid.append(feedRecipeArray[indexPath.row]!.uuid!)
        let post = self.storyboard?.instantiateViewController(withIdentifier: "NewViewRecipeVC") as! NewViewRecipeVC
        // self.present(post, animated: true, completion: nil)
        self.navigationController?.pushViewController(post, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.feedRecipeArray.count-1 && loading == false {
            self.loadMore()
        }
    }


    @IBAction func nameTapped(_ sender: UIGestureRecognizer) {
        let location = sender.location(in: self.view)
        let row = tableView.indexPathForRow(at: location)
        let username = self.feedRecipeArray[row!.row]!.username!
        if username == PFUser.current()!.username! {
            //If it is users own post then go home
            let home = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as! NewProfileVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            //If user is someone elses post then go to their page
            guestname.append(username)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! NewGuestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }

    }
    
}
