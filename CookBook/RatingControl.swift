//
//  RatingControl.swift
//  CookBook
//
//  Created by Edward Day on 11/01/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit

/*@IBDesignable*/ class RatingControl: UIStackView {
    
    private var ratingButtons = [UIButton]()
    
    var rating = 5 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    /*@IBInspectable*/ var starSize: CGSize = CGSize(width: 14.0, height: 14.0) {
        didSet{
            setupButtons()
        }
    }
    /*@IBInspectable */var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons() {
        //clear existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        ratingButtons.removeAll()
        for _ in 0..<starCount{

            // Create the button
            
            let button = UIButton()
            button.backgroundColor = UIColor.white
            button.setImage(filledStar, for: .selected)
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

            
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
           updateButtonSelectionStates()
    }
    
 
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }


}
