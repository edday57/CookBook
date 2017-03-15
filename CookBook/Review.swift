//
//  Review.swift
//  CookBook
//
//  Created by Edward Day on 14/03/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import Foundation
import UIKit


class Review {
    // MARK: Properties
    
    var username: String?
    var ava: UIImage?
    var fullname: String?
    var review: String?
    var rating: Int?

    
    init?(username: String?, ava: UIImage?, rating: Int?, review: String?, fullname: String?) {
        // Initialize stored properties.
        self.username = username
        self.ava = ava
        self.rating = rating
        self.fullname = fullname
        self.review = review


    }
    
}
