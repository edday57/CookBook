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

    let lightBlue = UIColor(colorLiteralRed: 88/255, green: 190/255, blue: 239/255, alpha: 1)
    let lightGreen = UIColor(colorLiteralRed: 105/255, green: 212/255, blue: 66/255, alpha: 1)
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var avaImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        followBtn.setTitle("FOLLOW", for: UIControlState.normal)
        followBtn.layer.backgroundColor = UIColor.white.cgColor
        followBtn.layer.cornerRadius = 2
        followBtn.layer.masksToBounds = true
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = self.lightBlue.cgColor
        followBtn.setTitleColor(self.lightBlue, for: UIControlState.normal)

        
    }

    //tapped follow / unfollow
    @IBAction func followBtnTapped(_ sender: AnyObject) {
        
        let title = followBtn.title(for: UIControlState.normal)!
        print(title)
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = usernameLbl.text
            object.saveInBackground(block: { (success:Bool, error:Error?) in
                if success {
                    self.followBtn.setTitle("FOLLOWING", for: UIControlState.normal)
                    self.followBtn.layer.cornerRadius = 2
                    self.followBtn.layer.masksToBounds = true
                    self.followBtn.layer.borderWidth = 0
                    self.followBtn.layer.backgroundColor = self.lightGreen.cgColor
                    self.followBtn.setTitleColor(UIColor.white, for: UIControlState.normal)

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
                                self.followBtn.setTitle("FOLLOW", for: UIControlState.normal)
                                self.followBtn.layer.backgroundColor = UIColor.white.cgColor
                                self.followBtn.layer.cornerRadius = 2
                                self.followBtn.layer.masksToBounds = true
                                self.followBtn.layer.borderWidth = 1
                                self.followBtn.layer.borderColor = self.lightBlue.cgColor
                                self.followBtn.setTitleColor(self.lightBlue, for: UIControlState.normal)

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


    override func layoutSubviews() {
        super.layoutSubviews()
        avaImg.layer.cornerRadius = 22
        avaImg.clipsToBounds = true
    }
}
