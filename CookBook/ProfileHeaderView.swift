//
//  ProfileHeaderVC.swift
//  CookBook
//
//  Created by Edward Day on 04/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse

class ProfileHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func followButtonClicked(_ sender: AnyObject) {
        let title = button.title(for: UIControlState.normal)!
        print(title)
        if title == "Follow" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = guestname.last!
            object.saveInBackground(block: { (success:Bool, error:Error?) in
                if success {
                    self.button.setTitle("Following", for: UIControlState.normal)
                } else {
                    print(error!.localizedDescription)
                }
            })
        } else {
            
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()!.username!)
            query.whereKey("following", equalTo: guestname.last!)
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackground(block: { (success:Bool, error:Error?) in
                            if success {
                                self.button.setTitle("Follow", for: UIControlState.normal)
                            } else {
                                print(error!.localizedDescription)
                            }
                        })
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
    }

    
}
