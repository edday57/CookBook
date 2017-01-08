//
//  ProfileHeaderVC.swift
//  CookBook
//
//  Created by Edward Day on 04/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse
import CoreImage

class ProfileHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var container: UIView!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        
        //allignment
        let width = UIScreen.main.bounds.width
        
        //avaImg.frame = CGRect(x: 12, y: 12, width: 112, height: 112)
        postTitle.frame = CGRect(x: width / 16.3, y: 140, width: width / 4, height: 17)
        posts.frame = CGRect(x: width / 16.3, y: 160, width: width / 4, height: 30)
        
        followersTitle.frame = CGRect(x: width / 2.4, y: 140, width: width / 4, height: 17)
        followers.frame = CGRect(x: width / 2.4, y: 160, width: width / 4, height: 30)
        
        followingTitle.frame = CGRect(x: width / 1.37, y: 140, width: width / 4, height: 17)
        following.frame = CGRect(x: width / 1.37, y: 160, width: width / 4, height: 30)
        
        avaImg.layer.cornerRadius = 56
        avaImg.clipsToBounds = true
        
        avaImg.layer.borderColor = UIColor.white.cgColor
        avaImg.layer.borderWidth = 2
        
        
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowRadius = 3
        container.layer.shadowOffset = CGSize(width: 0, height: 1)
        container.layer.shadowOpacity = 1
        
        button.layer.cornerRadius = 6
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        
     //   let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
    //    let blurView = UIVisualEffectView(effect: blurEffect)
      //  blurView.frame = backgroundImage.bounds
       // blurView.alpha = 0.7
      //  applyBlurEffect(image: backgroundImage.image!)
        let context = CIContext(options: nil)
        let imageToBlur = CIImage(image:backgroundImage.image!)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter!.setValue(imageToBlur, forKey: "inputImage")
        blurfilter!.setValue(1.8, forKey: "inputRadius")
        let resultImage = blurfilter!.value(forKey: "outputImage") as! CIImage
        let cgImage = context.createCGImage(resultImage, from: resultImage.extent)
        let blurredImage = UIImage(cgImage: cgImage!)
        backgroundImage.image = blurredImage
    
        
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
