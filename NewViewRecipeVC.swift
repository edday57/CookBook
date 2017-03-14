//
//  NewViewRecipeVC.swift
//  CookBook
//
//  Created by Edward Day on 11/01/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit
import Parse

var postuuid = [String]()

class NewViewRecipeVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var mainContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var mainContainer: UIView!

    var darkMode:Bool = Bool()
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
    
    @IBOutlet weak var reviewsBtn: UIButton!
    @IBOutlet weak var stepsBtn: UIButton!
    @IBOutlet weak var ingredientsBtn: UIButton!

    @IBOutlet weak var stepsView: UIView!
    @IBOutlet weak var stepsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stepsTextView: UITextView!

    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var ingredientsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var reviewsView: UIView!
    @IBOutlet weak var reviewsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewsTableView: UITableView!
    
    
    var avaArray = [PFFile]()
    var nameArray = [String]()
    var dateArray = [Date]()
    var titleArray = [String]()
    var additionalInfoEnabledArray = [Int]()
    var uuidArray = [String]()
    var stepsArray = [String]()
    var ingredientsArray = [String]()
    var username = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set nav bar title
        navigationItem.title = "CookBook"
        
        //self.mainContainerHeight.constant = 700
        
        //Dark Mode Config
        let defaults = UserDefaults.standard
        darkMode = defaults.bool(forKey: "darkMode")
        if darkMode == true {
            imageOverlay.image = UIImage(named: "Black Gradient - Food Overlay")
            recipeName.textColor = UIColor.white
        }
        
        //Set review height
        reviewsViewHeight.constant = UIScreen.main.bounds.height - 164
        
        //Avatar round config
        avaImage.layer.cornerRadius = avaImage.bounds.width / 2
        avaImage.clipsToBounds = true
        

        
        //Set recipe as default segment
        ingredientsSegment()
        
        ratingControl.rating = 0
        // Do any additional setup after loading the view.
        
        
        //Server Data Retrival for Post
        let postQuery = PFQuery(className: "posts")
        //Look for the post with the specified identifier
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            //If there are no errors then...
            if error == nil {
                
                //Clean Up
                self.avaArray.removeAll(keepingCapacity: false)
                self.nameArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                self.additionalInfoEnabledArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                self.stepsArray.removeAll(keepingCapacity: false)
                self.ingredientsArray.removeAll(keepingCapacity: false)
                
                //Retrive items
                for object in objects! {
                    self.recipeName.text = (object.value(forKey: "title") as! String)
                    self.username = (object.value(forKey: "username") as! String)    //////////This needs to be changed to use actual name instead of username ////////
                    self.timeLbl.text = "\((object.value(forKey: "time") as! Int)) min"
                    let pictureFile = object.value(forKey: "picture") as! PFFile
                    pictureFile.getDataInBackground(block: { (data:Data?, error:Error?) in
                        if error == nil {
                            self.userImage.image = UIImage(data: data!)
                        }
                    })
                    self.dateArray.append(object.createdAt!)
                    self.calculateDate(self.dateArray.last!) ////Turn the date into a readable format using the function defined below
                    self.additionalInfoEnabledArray.append(object.value(forKey: "additionalInfoEnabled")as! Int)   ///Use this later to help with configuring instructions section size///////
                    self.ingredientsArray = object.value(forKey: "ingredientsArray") as! [String]
                    self.stepsArray = object.value(forKey: "instructionsArray") as! [String]
                    self.convertIngredients()
                    self.convertSteps()
                }
                let userQuery = PFUser.query()
                userQuery?.whereKey("username", equalTo: self.username)
                userQuery?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                    if error == nil {
                        for object in objects! {
                            self.nameLbl.text = (object.value(forKey: "fullname") as! String).capitalized
                            let avaFile = object.value(forKey: "ava") as! PFFile
                            avaFile.getDataInBackground(block: { (data:Data?, error:Error?) in
                                if error == nil {
                                    self.avaImage.image = UIImage(data: data!)
                                }
                            })
                        }
                    }
                })
            }
            let reviewsCountQuery = PFQuery(className: "ratings")
            reviewsCountQuery.whereKey("postid", equalTo: postuuid.last!)
            reviewsCountQuery.whereKey("review", notEqualTo: "")
            reviewsCountQuery.countObjectsInBackground(block: { (count:Int32, error:Error?) in
                if error == nil {
                    self.reviewsLbl.text = "\(count)"
                } else {
                    print(error!.localizedDescription)
                }
            })
            let ratingQuery = PFQuery(className: "ratings")
            ratingQuery.whereKey("postid", equalTo: postuuid.last!)
            ratingQuery.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                if error == nil {
                    var count = 1
                    var total = 5
                    for object in objects! {
                        count += 1
                        total += object.value(forKey: "rating") as! Int
                    }
                    let rating: Int = total / count
                    //print(rating)
                    self.ratingControl.rating = rating
                } else {
                    print(error!.localizedDescription)
                }
            })
            let isReviewedQuery = PFQuery(className: "ratings")
            
        }
    loadReviews()
    }
    
    //Date Function
    func calculateDate(_ date: Date) {
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.none
        
        
        dateLbl.text = "\(formatter.string(from: dateArray.last!))"
        //dateLbl.sizeToFit()
    }
    
    //Convert Ingredients Array to Unordered List
    func convertIngredients(){
        var ingredientsList = ""
        for item in ingredientsArray{
            ingredientsList.append("- \(item) \n")
        }
        ingredientsTextView.text = ingredientsList
        ingredientsTextView.sizeToFit()
        ingredientsViewHeight.constant = 37 + 8 + ingredientsTextView.frame.height
        if segment == "ingredients" {
            ingredientsSegment()
        }
    }
    
    func convertSteps() {
        var stepsList = ""
        var i = 0
        for item in stepsArray{
            i += 1
            stepsList.append("\(i). \(item) \n")
        }
        stepsTextView.text = stepsList
        stepsTextView.sizeToFit()
        stepsViewHeight.constant = 37 + 8 + stepsTextView.frame.height
        if segment == "steps" {
            stepsSegment()
        }
    }
    

    //Segment Control
    /////////////////////////////////////////////////

    @IBAction func reviewsBtnTapped(_ sender: Any) {
        reviewsSegment()
    }

    @IBAction func stepsBtnTapped(_ sender: Any) {
        stepsSegment()
    }
    
    @IBAction func ingredientsBtnTapped(_ sender: Any) {
        ingredientsSegment()
    }

 
    func ingredientsSegment() {
        let customGrey = UIColor(colorLiteralRed: 152/255, green: 152/255, blue: 152/255, alpha: 1)
        if segment != "ingredients" {
            segment = "ingredients"
            
            //Change fonts
            ingredientsBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            stepsBtn.setTitleColor(customGrey, for: UIControlState.normal)
            reviewsBtn.setTitleColor(customGrey, for: UIControlState.normal)
            
            stepsBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            reviewsBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            ingredientsBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        }
        if segment == "ingredients" {
            mainContainerHeight.constant = 433 + ingredientsViewHeight.constant
            ingredientsView.isHidden = false
            stepsView.isHidden = true
            reviewsView.isHidden = true
        }
    }
    
    func stepsSegment() {
        let customGrey = UIColor(colorLiteralRed: 152/255, green: 152/255, blue: 152/255, alpha: 1)
        if segment != "steps" {
            segment = "steps"
            
            //Change fonts
            stepsBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            reviewsBtn.setTitleColor(customGrey, for: UIControlState.normal)
            ingredientsBtn.setTitleColor(customGrey, for: UIControlState.normal)
            
            ingredientsBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            reviewsBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            stepsBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        }
        if segment == "steps" {
            mainContainerHeight.constant = 433 + stepsViewHeight.constant
            stepsView.isHidden = false
            ingredientsView.isHidden = true
            reviewsView.isHidden = true
        }
    }
    
    func reviewsSegment() {
        let customGrey = UIColor(colorLiteralRed: 152/255, green: 152/255, blue: 152/255, alpha: 1)
        if segment != "reviews" {
            segment = "reviews"
            
            //Change fonts
            reviewsBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            stepsBtn.setTitleColor(customGrey, for: UIControlState.normal)
            ingredientsBtn.setTitleColor(customGrey, for: UIControlState.normal)
            
            stepsBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            ingredientsBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            reviewsBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        }
        if segment == "reviews" {
            mainContainerHeight.constant = 425 + reviewsViewHeight.constant
            stepsView.isHidden = true
            ingredientsView.isHidden = true
            reviewsView.isHidden = false
        }
    }

    /////////////////////////////////////////////////
    

    @IBAction func backBtnTapped(_ sender: Any) {
        if !postuuid.isEmpty {
            postuuid.removeLast()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nameTapped(_ sender: Any) {
        if username == PFUser.current()!.username! {
            //If it is users own post then go home
            let home = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as! NewProfileVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            //If user is someone elses post then go to their page
            guestname.append(username)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! NewGuestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }

    @IBAction func menuBtnTapped(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.view.tintColor = UIColor.darkGray
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) {
            UIAlertAction in
            self.confirmDelete()
        }
        let  cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
            UIAlertAction in
        }
        if username == PFUser.current()!.username {
        alert.addAction(deleteAction)
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func confirmDelete(){
        let alert:UIAlertController = UIAlertController(title: "Delete post?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.view.tintColor = UIColor.darkGray
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) {
            UIAlertAction in
            self.deletePost()
        }
        let  cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
            UIAlertAction in
        }
        if username == PFUser.current()!.username {
            alert.addAction(deleteAction)
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

    }

    func deletePost() {
        
        let query = PFQuery(className: "posts")
        query.whereKey("uuid", equalTo: postuuid.last!)
        query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                for object in objects! {
                    object.deleteInBackground(block: { (success:Bool, error:Error?) in
                        if success {
                            if !postuuid.isEmpty {
                                postuuid.removeLast()
                            }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploadedRecipe"), object: nil)
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                }
            } else {
                print(error!.localizedDescription)
            }
        })

    }
    
    
    
    /////////////////////////////////
    /////Review table view setup/////
    /////////////////////////////////

    var reviewsNumber: Int = 5
    
    //Arrays for review data to be stored in
    var reviewArray: Array <Review?>= []

    
    //fetch data from server
    func loadReviews() {
        let query = PFQuery(className: "ratings")
        query.whereKey("review", notEqualTo: "")
        query.whereKey("postid", equalTo: postuuid.last!)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                if objects!.count > 0{
                    self.reviewArray.removeAll(keepingCapacity: false)
                    self.reviewArray = [Review?](repeatElement(nil, count: objects!.count))
                    for i in 0...objects!.count - 1 {
                        //print(String(i))
                        let object: AnyObject = objects![i]
                        let reviewUsername = object.value(forKey: "from")as! String
                        let reviewReview = object.value(forKey: "review")as! String
                        let reviewRating = object.value(forKey: "rating")as! Int
                        let userQuery = PFUser.query()
                        userQuery?.whereKey("username", equalTo: reviewUsername)
                        userQuery?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                            if error == nil {
                                for object in objects! {
                                    let reviewFullname = object.value(forKey: "fullname")as! String
                                    let reviewAva = object.value(forKey: "ava")as! PFFile
                                    let review = Review(username: reviewUsername, ava: reviewAva, rating: reviewRating, review: reviewReview, fullname: reviewFullname)
                                    self.reviewArray[i] = review
                                    self.reviewsTableView.reloadData()
                                }
                            } else {
                                print(error!.localizedDescription)
                            }
                        })
                        
                    }
                    
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
 
    
    //config functions
    //height for cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    //number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray.count
    }
    
    //content for cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        if reviewArray[indexPath.row] != nil {
            reviewArray[indexPath.row]!.ava!.getDataInBackground(block: { (data:Data?, error:Error?) in
                if error == nil {
                    cell.reviewerImg.image = UIImage(data: data!)
                }else {
                    print(error!.localizedDescription)
                }
            })
            cell.reviewerName.text = reviewArray[indexPath.row]!.fullname!.capitalized
            cell.ratingControl.rating = reviewArray[indexPath.row]!.rating!
            cell.review.text = reviewArray[indexPath.row]!.review!
        }

        return cell
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
