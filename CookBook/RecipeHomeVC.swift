//
//  RecipeHomeVC.swift
//  CookBook
//
//  Created by Edward Day on 25/08/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit


class RecipeHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Sets rows in table view

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    
    //Sets row content
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyCellTableViewCell
        let recipe = recipes[indexPath.row]
        
        cell.recipeName.text = recipe.name
        cell.cellImage.image = recipe.photo
        cell.recipeTime.text = "\(recipe.time) mins"
        
  
        //Add a shadow to the cell view
        cell.cellView.layer.shadowOpacity = 0.4
        cell.cellView.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        cell.cellView.layer.shadowRadius = 4.0
        
        
        //Add border to gradient view
        cell.gradientView.layer.borderWidth = 2.0
        cell.gradientView.layer.borderColor = UIColor.white.cgColor
        
        //Adds a shadow to image holder
        cell.imageHolder.layer.shadowOpacity = 0.4
        cell.imageHolder.layer.shadowOffset = CGSize(width: 2.0, height: 0.0)
        cell.imageHolder.layer.shadowRadius = 2.0

        //Makes image adapt to device size
        cell.imageHolderWidth.constant = (view.bounds.width * 0.5)
        
        

        
        //Makes cell view white
        cell.cellView.layer.backgroundColor = UIColor.white.cgColor
        
        
        //Returns the cell
        return cell
    }


    //OUTLETS
    
    @IBOutlet weak var searchBar: UISearchBar!

    //VARIABLES
    var recipes = [Recipe]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        //Make search bar transparent
        let image = UIImage()
        searchBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        searchBar.scopeBarBackgroundImage = image
        
        //Load sample recipes
        loadSampleRecipes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSampleRecipes() {
        let photo1 = UIImage(named: "recipe1")!
        let recipe1 = Recipe(name: "Chicken Shawarma", photo: photo1, time: 40, ingredients: "Chicken, Wrap, Mixed Salad, Mustard", instructions: "1. Add all ingredients.", isPrivate: true, additionalInfo: "This is just a test")!
        recipes += [recipe1]
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
