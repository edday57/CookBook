//
//  FeedCell.swift
//  CookBook
//
//  Created by Edward Day on 16/03/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var feedRecipeName: UILabel!
    @IBOutlet weak var feedFullname: UILabel!
    @IBOutlet weak var feedRating: RatingControl!
    @IBOutlet weak var feedAva: UIImageView!
    @IBOutlet weak var feedImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        feedAva.layer.cornerRadius = 32 / 2
        // Initialization code
        infoView.layer.shadowOffset = CGSize(width: 0, height: 3)
        infoView.layer.shadowRadius = 2
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOpacity = 0.1
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
