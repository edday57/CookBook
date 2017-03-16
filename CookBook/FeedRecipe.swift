//
//  FeedRecipe.swift
//  CookBook
//
//  Created by Edward Day on 15/03/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import Foundation
import UIKit


class FeedRecipe {
    // MARK: Properties
    
    var username: String?
    var ava: UIImage?
    var fullname: String?
    var img: UIImage?
    var rating: Int?
    var uuid: String?
    var recipeName: String?
    
    init?(username: String?, ava: UIImage?, rating: Int?, img: UIImage?, fullname: String?, uuid: String?, recipeName: String?) {
        // Initialize stored properties.
        self.username = username
        self.ava = ava
        self.rating = rating
        self.fullname = fullname
        self.img = img
        self.uuid = uuid
        self.recipeName = recipeName
        
    }
    
}
