//
//  ProfileHeaderVC.swift
//  CookBook
//
//  Created by Edward Day on 04/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    @IBOutlet weak var navBar: UINavigationBar!
        
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
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
}
