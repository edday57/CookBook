//
//  NewGuestHeaderView.swift
//  CookBook
//
//  Created by Edward Day on 05/03/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit
import Parse

class NewGuestHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var buttonBg: UIView!
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
        avaImg.clipsToBounds = true
        
        avaImg.layer.borderColor = UIColor.white.cgColor
        avaImg.layer.borderWidth = 3
        
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowRadius = 3
        container.layer.shadowOffset = CGSize(width: 0, height: 1)
        container.layer.shadowOpacity = 0.4
        buttonBg.layer.cornerRadius = 8
        buttonBg.layer.borderWidth = 2.5
        buttonBg.layer.borderColor = UIColor.white.cgColor
        buttonBg.layer.shadowRadius = 1
        buttonBg.layer.shadowOpacity = 0.6
        buttonBg.layer.shadowOffset = CGSize(width: 1, height: 1)
        buttonBg.layer.backgroundColor = UIColor.clear.cgColor
    }

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
