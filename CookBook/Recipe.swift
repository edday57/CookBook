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
    var additionalInfoEnabled: Bool

    
    init?(name: String, photo: UIImage, time: Int, ingredients: String , instructions: String, additionalInfo: String?, additionalInfoEnabled: Bool) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.time = time
        self.ingredients = ingredients
        self.instructions = instructions
        self.additionalInfo = additionalInfo
        self.additionalInfoEnabled = additionalInfoEnabled
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }
    }
    
}
