//
//  NewGuestVC.swift
//  CookBook
//
//  Created by Edward Day on 05/03/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit
import Parse

var guestname = [String]()

class NewGuestVC: UICollectionViewController {

    var refresher: UIRefreshControl!
    //size of page
    var page: Int = 10
    //var privacy = "public"
    var uuidArray = [String]()
    
    var picArray = [PFFile]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.collectionView!.alwaysBounceVertical = true
        
        //Nav Title
        self.navigationItem.title = guestname.last
        
        //Custom Back Button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewGuestVC.back(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        //Swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NewGuestVC.back(_:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        //Pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(NewGuestVC.refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        collectionView?.sendSubview(toBack: refresher)
        
        //Call load posts function
        loadPosts()
    }

    
    //Back function
    func back(_ sender : UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
        //Remove last guest username from guest name array
        if !guestname.isEmpty {
            guestname.removeLast()
        }
        
    }
    
    //Refresh function
    func refresh() {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }

    //Load posts function
    func loadPosts() {
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: guestname.last!)
        query.limit = page
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                
                //Clean Up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                //find related objects
                for object in objects! {
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "picture")as! PFFile)
                }
                self.collectionView?.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    //load more while scrolling down
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height {
            self.loadMore()
        }
    }
    
    //Load more posts
    func loadMore() {
        //if there are unloaded posts
        if page <= picArray.count {
            //increase page size by 10
            page = page + 10
            
            //load more posts
            let query = PFQuery(className: "posts")
            query.whereKey("username", equalTo: guestname.last!)
            query.limit = page
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                if error == nil {
                    
                    //clean up
                    self.uuidArray.removeAll(keepingCapacity: false)
                    self.picArray.removeAll(keepingCapacity: false)
                    for object in objects! {
                        self.uuidArray.append(object.value(forKey: "uuid") as! String)
                        self.picArray.append(object.value(forKey: "picture") as! PFFile)
                    }
                    print("Loaded \(self.page) recipes!")
                    self.collectionView?.reloadData()
                } else {
                    print(error!.localizedDescription)
                }
            })
            
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }

    //Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: (self.view.frame.size.width / 2) , height: self.view.frame.size.width / 2)
        return size
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        if privacy == "public"{
            //get picture from pic array
            picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
                if error == nil {
                    cell.picImg.image = UIImage(data: data!)
                }
            }
        } else {
            cell.picImg.image = UIImage()
            //private config
        }
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! NewGuestHeaderView
        
        //header.posts.text = nil
        //header.following.text = nil
        //header.followers.text = nil
        
        
        
        //Get user data and set labels
        let infoQuery = PFUser.query()
        infoQuery?.whereKey("username", equalTo: guestname.last!)
        infoQuery?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                if objects!.isEmpty {
                    print("Wrong user!")
                }
                
                for object in objects! {
                    header.fullnameLbl.text = (object.object(forKey: "fullname") as? String)?.capitalized
                    header.aboutLbl.text = object.object(forKey: "about") as? String
                    
                    let avaFile:PFFile = (object.object(forKey: "ava") as? PFFile)!
                    avaFile.getDataInBackground(block: { (data:Data?, error:Error?) in
                        if error == nil {
                            header.avaImg.image = UIImage(data: data!)
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        
        //Check if the current user follows the guest that they are looking at
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.current()!.username!)
        followQuery.whereKey("following", equalTo: guestname.last!)
        followQuery.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                if count == 0 {
                    //They are not following them
                    header.button.setTitle("Follow", for: UIControlState.normal)
                    header.button.isUserInteractionEnabled = true
                } else {
                    //They are following them
                    header.button.setTitle("Following", for: UIControlState.normal)
                    header.button.isUserInteractionEnabled = true
                    
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        //posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: guestname.last!)
        posts.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                header.posts.text = "\(count)"
            }
        }
        
        //followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: guestname.last!)
        followers.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                header.followers.text = "\(count)"
            }
        }
        
        //following
        let following = PFQuery(className: "follow")
        following.whereKey("follower", equalTo: guestname.last!)
        following.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                header.following.text = "\(count)"
            }
        }
        
        //Implement tap gestures
        //tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(NewGuestVC.postsTap))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(NewGuestVC.followingTap))
        followingTap.numberOfTapsRequired = 1
        header.following.isUserInteractionEnabled = true
        header.following.addGestureRecognizer(followingTap)
        
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(NewGuestVC.followersTap))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)

        return header
    }

    //Tap posts label
    func postsTap() {
        if !picArray.isEmpty {
            let index = NSIndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    
    //Tap following label
    func followingTap() {
        user = guestname.last!
        show_ = "Following"
        
        let following = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! FollowersVC
        self.navigationController?.pushViewController(following, animated: true)
    }
    
    //Tap followers label
    func followersTap() {
        user = guestname.last!
        show_ = "Followers"
        
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! FollowersVC
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    //Go to post
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        postuuid.append(uuidArray[indexPath.row])
        
        let post = self.storyboard?.instantiateViewController(withIdentifier: "NewViewRecipeVC") as! NewViewRecipeVC
        self.navigationController?.pushViewController(post, animated: true)
    }

}
