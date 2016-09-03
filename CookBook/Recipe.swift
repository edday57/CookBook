//
//  Recipe.swift
//  CookBook
//
//  Created by Edward Day on 01/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import Foundation
import UIKit

class Recipe {
    // MARK: Properties
    
    var name: String
    var photo: UIImage
    var time: Int
    var ingredients: String
    var instructions: String
    var additionalInfo: String?
    var isPrivate: Bool
    
    init?(name: String, photo: UIImage, time: Int, ingredients: String , instructions: String, isPrivate: Bool, additionalInfo: String?) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.time = time
        self.ingredients = ingredients
        self.instructions = instructions
        self.additionalInfo = additionalInfo
        self.isPrivate = isPrivate
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }
    }
    
}
