//
//  NewViewRecipeVC.swift
//  CookBook
//
//  Created by Edward Day on 11/01/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit
import Parse

class NewViewRecipeVC: UIViewController {
    
    var darkMode:Bool = true
    var segment = String()
    
    //Top Section
    @IBOutlet weak var imageOverlay: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    
    //Post Info Section
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var reviewsLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    var rating = 0
    
    @IBOutlet weak var recipeBtn: UIButton!
    @IBOutlet weak var reviewsBtn: UIButton!
    @IBOutlet weak var testBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dark Mode Config
        if darkMode == true {
            imageOverlay.image = UIImage(named: "Black Gradient - Food Overlay")
            recipeName.textColor = UIColor.white
        }
        
        //Avatar round config
        avaImage.layer.cornerRadius = avaImage.bounds.width / 2
        avaImage.clipsToBounds = true
        
        //Btn Config
        recipeBtn.layer.cornerRadius = 8
        recipeBtn.clipsToBounds = true
        reviewsBtn.layer.cornerRadius = 8
        reviewsBtn.clipsToBounds = true
        recipeBtn.layer.borderColor = UIColor.lightGray.cgColor
        reviewsBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        //Set recipe as default segment
        recipeSegment()
        
        ratingControl.rating = 4
        // Do any additional setup after loading the view.
    }
    
    //Segment Control
    /////////////////////////////////////////////////
    @IBAction func recipeBtnTapped(_ sender: Any) {
        recipeSegment()
    }
    @IBAction func reviewsBtnTapped(_ sender: Any) {
        reviewsSegment()
    }

    func recipeSegment() {
        if segment != "recipe" {
            //Change Btn Looks
            recipeBtn.layer.borderWidth = 1
            reviewsBtn.layer.borderWidth = 0
            segment = "recipe"
        }
    }
    
    func reviewsSegment() {
        if segment != "reviews" {
            //Change Btn Looks
            recipeBtn.layer.borderWidth = 0
            reviewsBtn.layer.borderWidth = 1
            segment = "reviews"
        }
    }

    /////////////////////////////////////////////////
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
