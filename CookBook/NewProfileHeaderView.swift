//
//  NewProfileHeaderView.swift
//  CookBook
//
//  Created by Edward Day on 07/01/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit
var privacy = "public"
class NewProfileHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    
    @IBOutlet weak var publicLbl: UILabel!
    @IBOutlet weak var publicView: UIView!
    @IBOutlet weak var privateView: UIView!
    @IBOutlet weak var privateLbl: UILabel!
    
    @IBOutlet weak var privateBar: UIView!
    @IBOutlet weak var publicBar: UIView!
    @IBOutlet weak var screen: UIView!
    override func awakeFromNib() {
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
        avaImg.clipsToBounds = true
        
        avaImg.layer.borderColor = UIColor.white.cgColor
        avaImg.layer.borderWidth = 3
        
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowRadius = 3
        container.layer.shadowOffset = CGSize(width: 0, height: 1)
        container.layer.shadowOpacity = 0.4
        
        let publicTap1 = UITapGestureRecognizer(target: self, action: #selector(NewProfileHeaderView.publicTap))
        publicTap1.numberOfTapsRequired = 1
        let publicTap2 = UITapGestureRecognizer(target: self, action: #selector(NewProfileHeaderView.publicTap))
        publicTap2.numberOfTapsRequired = 1
        publicLbl.isUserInteractionEnabled = true
        publicView.isUserInteractionEnabled = true
        publicView.addGestureRecognizer(publicTap1)
        publicLbl.addGestureRecognizer(publicTap2)
        
        let privateTap1 = UITapGestureRecognizer(target: self, action: #selector(NewProfileHeaderView.privateTap))
        privateTap1.numberOfTapsRequired = 1
        let privateTap2 = UITapGestureRecognizer(target: self, action: #selector(NewProfileHeaderView.privateTap))
        privateTap2.numberOfTapsRequired = 1
        privateLbl.isUserInteractionEnabled = true
        privateView.isUserInteractionEnabled = true
        privateView.addGestureRecognizer(privateTap1)
        privateLbl.addGestureRecognizer(privateTap2)
        
    }
    
    func publicTap() {

        if privacy != "public"{
            privacy = "public"
            publicBar.isHidden = false
            privateBar.isHidden = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setPublic"), object: nil)
        }
        
    }

    func privateTap() {
        if privacy != "private"{
            privacy = "private"
            publicBar.isHidden = true
            privateBar.isHidden = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setPrivate"), object: nil)
        }
    }

}
