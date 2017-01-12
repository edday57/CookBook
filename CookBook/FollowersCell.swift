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
    @IBOutlet weak var followBg: UIView!
    let lightBlue = UIColor(colorLiteralRed: 88/255, green: 190/255, blue: 239/255, alpha: 1)
    let lightGreen = UIColor(colorLiteralRed: 139/255, green: 241/255, blue: 111/255, alpha: 1)
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var avaImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        followBtn.setTitle("", for: UIControlState.normal)
        followBg.layer.backgroundColor = UIColor.lightGray.cgColor
        followBg.layer.cornerRadius = 5
        followBg.layer.masksToBounds = true

        
    }

    @IBAction func followBtnTapped(_ sender: Any) {
        
        let title = followBtn.title(for: UIControlState.normal)!
        print(title)
        if title == "" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = usernameLbl.text
            object.saveInBackground(block: { (success:Bool, error:Error?) in
                if success {
                    self.followBtn.setTitle("", for: UIControlState.normal)
                    self.followBg.layer.cornerRadius = 5
                    self.followBg.layer.masksToBounds = true
                    self.followBg.layer.backgroundColor = self.lightGreen.cgColor

                    
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
                                self.followBtn.setTitle("", for: UIControlState.normal)
                                self.followBg.layer.backgroundColor = UIColor.lightGray.cgColor
                                self.followBg.layer.cornerRadius = 5
                                self.followBg.layer.masksToBounds = true


                                
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
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
        avaImg.layer.borderWidth = 1
        avaImg.layer.borderColor = UIColor.lightGray.cgColor
        avaImg.clipsToBounds = true
    }
}
