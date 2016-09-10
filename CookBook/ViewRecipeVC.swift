//
//  ViewRecipeViewController.swift
//  CookBook
//
//  Created by Edward Day on 27/08/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit

class ViewRecipeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate{
    

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    
    //RECIPE OUTLETS
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var additionalInfoView: UITextView!
    @IBOutlet weak var additionalInfoLabel: UILabel!

    @IBOutlet weak var containerHeight: NSLayoutConstraint!

    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recipe!.additionalInfoEnabled == true && recipe!.additionalInfo != "Add any additional info here!"{
            containerHeight.constant = 770
            additionalInfoView.text = recipe!.additionalInfo
        }
        if recipe!.additionalInfoEnabled == false {
            containerHeight.constant = 620
            additionalInfoView.isHidden = true
            additionalInfoLabel.isHidden = true
            
        }
        navigationItem.title = "CookBook"
        
        //Adds a white border to the gradient view
        gradientView.layer.borderWidth = 1.0
        gradientView.layer.borderColor = UIColor.white.cgColor
        
        //Adds a shadow to the gradient
        gradientView.layer.shadowOpacity = 0.4
        gradientView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        gradientView.layer.shadowRadius = 5.0
        

        
        userImage.image = recipe!.photo
        recipeName.text = recipe!.name
        recipeTime.text = "\(recipe!.time) mins"
        ingredientsTextView.text = "Ingredients: \(recipe!.ingredients)"
        instructionsTextView.text = recipe!.instructions

        recipeName.layer.shadowOpacity = 0.5
        recipeName.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        recipeName.layer.shadowRadius = 6
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
       
    
    //User cancels creating a new recipe
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }



    

    
    
}
