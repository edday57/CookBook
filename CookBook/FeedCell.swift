//
//  FeedCell.swift
//  CookBook
//
//  Created by Edward Day on 16/03/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var feedRecipeName: UILabel!
    @IBOutlet weak var feedFullname: UILabel!
    @IBOutlet weak var feedRating: RatingControl!
    @IBOutlet weak var feedAva: UIImageView!
    @IBOutlet weak var feedImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
