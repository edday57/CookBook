//
//  ProfileVC.swift
//  CookBook
//
//  Created by Edward Day on 04/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse

class ProfileVC: UICollectionViewController {

    var refresher: UIRefreshControl!
    //size of page
    var page: Int = 9
    
    var uuidArray = [String]()
    
    var picArray = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(ProfileVC.refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        collectionView?.sendSubview(toBack: refresher)
        //recive notification from editVC
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.reload(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.uploaded(_:)), name: NSNotification.Name(rawValue: "uploadedRecipe"), object: nil)
        
     
                
        //load posts
        loadPosts()
        
    }
    
    
    //refresh function
    func refresh() {
        PFUser.current()?.fetchInBackground(block: { (objects:PFObject?, error:Error?) in
            if error == nil {
                self.collectionView?.reloadData()
               
            }
        })
        
        refresher.endRefreshing()
    }
    
    
    func reload(_ notification:Notification) {
        collectionView?.reloadData()
    }
    
    func uploaded(_ notification:Notification) {
        loadPosts()
    }
    
    //load posts function
    func loadPosts() {
        
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = page
        query.findObjectsInBackground (block: { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                
                //clean up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                //find related objects to request
                for object in objects! {
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "picture") as! PFFile)
                }
                self.collectionView?.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        })
        
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
            //increase page size by 9
            page = page + 9
            
            //load more posts
            let query = PFQuery(className: "posts")
            query.whereKey("username", equalTo: PFUser.current()!.username!)
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
        // #warning Incomplete implementation, return the number of items
        return picArray.count
    }
    
    //Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
     
        let size = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
        return size
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        
        //get picture from pic array
        picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    
    /////////////////////////



    
    //Header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! ProfileHeaderView
        

        
        header.posts.text = nil
        header.following.text = nil
        header.followers.text = nil
        
        
        //Configure the nav bar
        
        self.navigationItem.title = PFUser.current()!.username!
        
        
        
        //Get user data and set labels
        header.fullnameLbl.text = (PFUser.current()!.object(forKey: "fullname") as? String)?.capitalized
        header.aboutLbl.text = PFUser.current()!.object(forKey: "about") as? String
        header.usernameLbl.text = "@\(PFUser.current()!.username!)"
        header.button.setTitle("Edit Profile", for: UIControlState.normal)
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                
                header.avaImg.image = UIImage(data: data!)
           }
        }
        let coverPhoto = PFUser.current()?.object(forKey: "coverPhoto") as? PFFile
        if coverPhoto != nil {
            //If a cover photo exists then set the cover photo as it
            coverPhoto?.getDataInBackground(block: { (data:Data?, error:Error?) in
                if error == nil {
                    header.backgroundImage.image = UIImage(data: data!)

                }
            })
        }

        
        //posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.current()!.username!)
        posts.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                header.posts.text = "\(count)"
            }
        }
        
        //followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: PFUser.current()!.username!)
        followers.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                header.followers.text = "\(count)"
            }
        }
        
        //following
        let following = PFQuery(className: "follow")
        following.whereKey("follower", equalTo: PFUser.current()!.username!)
        following.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                header.following.text = "\(count)"
            }
        }
        
        //Implement tap gestures
        //tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.postsTap))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        

        
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.followingTap))
        followingTap.numberOfTapsRequired = 1
        header.following.isUserInteractionEnabled = true
        header.following.addGestureRecognizer(followingTap)
        
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.followersTap))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)


        return header
    }

    //tapped posts label
    func postsTap() {
        if !picArray.isEmpty {
            let  index = NSIndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    
    //tapped followers label
    func followersTap() {
        user = PFUser.current()!.username!
        show_ = "Followers"
        
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! FollowersVC
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    func followingTap() {
        user = PFUser.current()!.username!
        show_ = "Following"
        
        let following = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! FollowersVC
        self.navigationController?.pushViewController(following, animated: true)
    }
    
    //User clicked log out
    @IBAction func logout(_ sender: AnyObject) {
        PFUser.logOutInBackground { (error:Error?) in
            if error == nil {
                
                //Remove saved login info
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
                
                let signin = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! LoginViewController
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController =  signin
            }
        }
    }
    
    //Go to post
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        postuuid.append(uuidArray[indexPath.row])
        
        let post = self.storyboard?.instantiateViewController(withIdentifier: "ViewRecipePublicVC") as! ViewRecipePublicVC
        self.navigationController?.pushViewController(post, animated: true)
    }
    
    @IBAction func unwindToProfilePage(sender: UIStoryboardSegue) {
    }
    ///////////////////////////////
    /*
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
 */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    
}
