//
//  FollowersCell.swift
//  CookBook
//
//  Created by Edward Day on 05/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse

class FollowersCell: UITableViewCell {

    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var avaImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
    }

    //tapped follow / unfollow
    @IBAction func followBtnTapped(_ sender: AnyObject) {
        
        let title = followBtn.title(for: UIControlState.normal)!
        print(title)
        if title == "Follow" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = usernameLbl.text
            object.saveInBackground(block: { (success:Bool, error:Error?) in
                if success {
                    self.followBtn.setTitle("Following", for: UIControlState.normal)
                } else {
                    print(error!.localizedDescription)
                }
            })
        } else {

            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()!.username!)
            query.whereKey("following", equalTo: usernameLbl.text!)
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackground(block: { (success:Bool, error:Error?) in
                            if success {
                                self.followBtn.setTitle("Follow", for: UIControlState.normal)
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
