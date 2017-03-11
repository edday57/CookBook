//
//  ReviewCell.swift
//  CookBook
//
//  Created by Edward Day on 10/03/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var ratingControl: RatingControl!
    var rating = 0
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var reviewerName: UILabel!
    @IBOutlet weak var reviewerImg: UIImageView!
    override func awakeFromNib() {
        ratingControl.rating = rating
        super.awakeFromNib()
        // Initialization code
        reviewerImg.layer.cornerRadius = reviewerImg.bounds.width / 2
        reviewerImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
