//
//  RecipeHomeVC.swift
//  CookBook
//
//  Created by Edward Day on 25/08/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse

class RecipeHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var noRecipes: UILabel!
    //Sets rows in table view
    @IBOutlet weak var recipeTableView: UITableView!

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    
    //Sets row content
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyCellTableViewCell
        let recipe = recipes[indexPath.row]

        
        let avaQuery = PFUser.current()?.value(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.userImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        cell.userImg.layer.cornerRadius = 35
        cell.userImg.clipsToBounds = true
        
        cell.recipeName.text = recipe.name
        cell.cellImage.image = recipe.photo
        cell.recipeTime.text = "\(recipe.time) mins"
        
  
        //Add a shadow to the cell view
        cell.cellView.layer.shadowOpacity = 0.4
        cell.cellView.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        cell.cellView.layer.shadowRadius = 4.0
        
        
        //Add border to gradient view
        cell.gradientView.layer.borderWidth = 1.0
        cell.gradientView.layer.borderColor = UIColor.white.cgColor
        
        //Adds a shadow to image holder
        cell.imageHolder.layer.shadowOpacity = 0.4
        cell.imageHolder.layer.shadowOffset = CGSize(width: 2.0, height: 0.0)
        cell.imageHolder.layer.shadowRadius = 2.0

        //Makes image adapt to device size
        cell.imageHolderWidth.constant = (view.bounds.width * 0.5)
        

        
        //Makes cell view white
        cell.cellView.layer.backgroundColor = UIColor.white.cgColor
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //Returns the cell
        return cell
    }


    //OUTLETS
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navigationBar: UINavigationBar!

    //VARIABLES
    var recipes = [Recipe]()
    var selectedRecipe: Recipe?
    var recipe: Recipe?
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        //Make search bar transparent
        let image = UIImage()
        searchBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        searchBar.scopeBarBackgroundImage = image
        
        //Load sample recipes
        loadSampleRecipes()
        if recipes.count == 0 {
            noRecipes.isHidden = false
        }
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        let attrs = [
            NSForegroundColorAttributeName : UIColor.white,
            //   NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 24)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs


        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(RecipeHomeVC.refresh), for: UIControlEvents.valueChanged)
        recipeTableView.addSubview(refresher)
        


    }
    
    func refresh() {
        recipeTableView.reloadData()
        refresher.endRefreshing()
    }
    
    func loadSampleRecipes() {
        let photo1 = UIImage(named: "recipe1")!
        let recipe1 = Recipe(name: "Chicken Shawarma", photo: photo1, time: 40, ingredients: "Chicken, Wrap, Mixed Salad, Mustard", instructions: "1. Add all ingredients.", additionalInfo: "This is just a test", additionalInfoEnabled: true)!
        recipes += [recipe1]
        
    }

    
    //Updates the table view after returning from CreateRecipe page
    @IBAction func unwindToRecipeList(sender: UIStoryboardSegue) {
        if sender.source is NewRecipeVC/*, let recipe = sourceViewController.recipe */{
            
            let newIndexPath = IndexPath(row: recipes.count, section: 0)
            if recipe != nil {
            recipes.append(recipe!)
            recipeTableView.insertRows(at: [newIndexPath], with: .bottom)
            noRecipes.isHidden = true
            }
        }
        
    }
 
    
    //Allows recipes to be deleted by sliding left
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            recipes.remove(at: indexPath.row)
            recipeTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            if recipes.count == 0 {
            noRecipes.isHidden = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       selectedRecipe = recipes[indexPath.row]
       performSegue(withIdentifier: "detailView", sender: self)
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailView") {
            let destinationViewController = segue.destination as! ViewRecipeNavBarVC
            let targetController = destinationViewController.topViewController as! ViewRecipeVC
            targetController.recipe = selectedRecipe

        }
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
