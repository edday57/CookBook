//
//  MyCellTableViewCell.swift
//  CookBook
//
//  Created by Edward Day on 26/08/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit

class MyCellTableViewCell: UITableViewCell {

    

    @IBOutlet weak var imageHolderWidth: NSLayoutConstraint!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var imageHolder: UIView!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeTime: UILabel!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
