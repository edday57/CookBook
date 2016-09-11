//
//  ViewRecipeViewController.swift
//  CookBook
//
//  Created by Edward Day on 27/08/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse


var postuuid = [String]()

class ViewRecipePublicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate{
    
    //Server arrays
    var avaArray = [PFFile]()
    var usernameArray = [String]()
    var dateArray = [Date]()
    
    var picArray = [PFFile]()
    var titleArray = [String]()
    var timeArray = [Int]()
    var instructionsArray = [String]()
    var ingredientsArray = [String]()
    var additionalInfoArray = [String]()
    var additionalInfoEnabledArray = [Int]()
    var uuidArray = [String]()
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var postUsername: UILabel!
    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //RECIPE OUTLETS
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var additionalInfoView: UITextView!
    @IBOutlet weak var additionalInfoLabel: UILabel!

    @IBOutlet weak var containerHeight: NSLayoutConstraint!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the title for the nav bar
        navigationItem.title = "CookBook"
        
        //Adds a white border to the gradient view
        gradientView.layer.borderWidth = 1.0
        gradientView.layer.borderColor = UIColor.white.cgColor
        
        //Adds a shadow to the gradient
        gradientView.layer.shadowOpacity = 0.4
        gradientView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        gradientView.layer.shadowRadius = 5.0


        //Adds a shadow to the recipe name
        recipeName.layer.shadowOpacity = 0.5
        recipeName.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        recipeName.layer.shadowRadius = 6
        
       /*
        let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {

                print("Help1")
                //Clean up
                self.avaArray.removeAll(keepingCapacity: false)
                self.usernameArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                self.timeArray.removeAll(keepingCapacity: false)
                self.ingredientsArray.removeAll(keepingCapacity: false)
                self.instructionsArray.removeAll(keepingCapacity: false)
                self.additionalInfoArray.removeAll(keepingCapacity: false)
                self.additionalInfoEnabledArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                
                //find related objects
                for object in objects! {
                    print("Help2")
                    self.avaArray.append(object.value(forKey: "ava")as! PFFile)
                    self.usernameArray.append(object.value(forKey: "username")as! String)
                    self.dateArray.append(object.createdAt!)
                    self.picArray.append(object.value(forKey: "picture")as! PFFile)
                    self.uuidArray.append(object.value(forKey: "uuid")as! String)
                    self.titleArray.append(object.value(forKey: "title")as! String)
                    self.timeArray.append(object.value(forKey: "time")as! Int)
                    self.instructionsArray.append(object.value(forKey: "instructions")as! String)
                    self.ingredientsArray.append(object.value(forKey: "ingredients")as! String)
                    self.additionalInfoArray.append(object.value(forKey: "additionalInfo")as! String)
                    self.additionalInfoEnabledArray.append(object.value(forKey: "additionalInfoEnabled")as! Int)
                }
                
                
            } else {
                print("Help3")
                print(error!.localizedDescription)
            }
        }
        
        
        //Put server data to UI
        recipeName.text = titleArray.last
        picArray.last?.getDataInBackground(block: { (data:Data?, error:Error?) in
            if error == nil {
                self.userImage.image = UIImage(data: data!)
            }
        })
        recipeTime.text = "\(timeArray.last) mins"
        ingredientsTextView.text = "Ingredients: \(ingredientsArray.last)"
        instructionsTextView.text = instructionsArray.last
        if additionalInfoEnabledArray.last == 1 {
            containerHeight.constant = 850
            additionalInfoView.text = additionalInfoArray.last
        } else {
            containerHeight.constant = 700
            additionalInfoView.isHidden = true
            additionalInfoLabel.isHidden = true
        }
        avaArray.last?.getDataInBackground(block: { (data:Data?, error:Error?) in
            if error == nil {
                self.avaImage.image = UIImage(data: data!)
            }
        })
        postUsername.text = usernameArray.last
        */
        //Calculate post data
        /*
        let from = dateArray.last
        let now = Date()
        let difference = NSCalendar.current.dateComponents([.second, .minute, .hour, .day, .weekOfMonth], from: from!, to: now)
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = DateFormatter.Style.none
        
        if difference.second! <= 0 {
            postDate.text = "NOW"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            postDate.text = "NOW"
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            postDate.text = "\(difference.minute) MINUTES AGO"
        }
        if difference.hour! > 0 && difference.day! == 0 {
            postDate.text = "\(difference.hour) HOURS AGO"
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            postDate.text = "\(difference.day) DAYS AGO"
        }
        if difference.weekOfMonth! < 0 {
            postDate.text = "\(formatter.string(from: dateArray.last!))"
        }
 */
 
        
        let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                
                //Clean up
                self.avaArray.removeAll(keepingCapacity: false)
                self.usernameArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                self.timeArray.removeAll(keepingCapacity: false)
                self.ingredientsArray.removeAll(keepingCapacity: false)
                self.instructionsArray.removeAll(keepingCapacity: false)
                self.additionalInfoArray.removeAll(keepingCapacity: false)
                self.additionalInfoEnabledArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    //self.titleArray.append(object.value(forKey: "title")as! String)
                    //  self.recipeName.text = self.titleArray.last
                    self.recipeName.text = (object.value(forKey: "title") as! String)
                    self.recipeTime.text = "\((object.value(forKey: "time") as! Int)) mins"
                    self.ingredientsTextView.text = "Ingredients: \((object.value(forKey: "ingredients") as! String))"
                    self.instructionsTextView.text = (object.value(forKey: "instructions")as! String)
                    self.postUsername.text = (object.value(forKey: "username")as! String)
                    self.additionalInfoEnabledArray.append(object.value(forKey: "additionalInfoEnabled")as! Int)
                    if self.additionalInfoEnabledArray.last == 1 {
                        self.additionalInfoView.text = (object.value(forKey: "additionalInfo") as! String)
                        self.containerHeight.constant = 850
                    } else {
                        self.containerHeight.constant = 700
                        self.additionalInfoView.isHidden = true
                        self.additionalInfoLabel.isHidden = true
                    }

                    
                    let avaFile = object.value(forKey: "ava") as! PFFile
                    avaFile.getDataInBackground(block: { (data:Data?, error:Error?) in
                        if error == nil {
                            self.avaImage.image = UIImage(data: data!)
                        }
                    })
                    let pictureFile = object.value(forKey: "picture") as! PFFile
                    pictureFile.getDataInBackground(block: { (data:Data?, error:Error?) in
                        if error == nil {
                            self.userImage.image = UIImage(data: data!)
                        }
                    })
                    self.dateArray.append(object.createdAt!)
                    self.calculateDate(self.dateArray.last!)
                    
                    
                }
            }
        }
 
        //show like button depending on whether it is liked or not
        let didLike = PFQuery(className: "likes")
        didLike.whereKey("by", equalTo: PFUser.current()?.username)
        didLike.whereKey("to", equalTo: postuuid.last)
        didLike.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                
                for object in objects! {
                    
                }
            }
        }
        }
    
    
    func calculateDate(_ date: Date) {
      //  let from = date
     //   let now = Date()
     //   let difference = NSCalendar.current.dateComponents([.second, .minute, .hour, .day, .weekOfMonth], from: from!, to: now)
        let formatter = DateFormatter()
       formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.none
      /*
        if difference.second! <= 0 {
           postDate.text = "NOW"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            postDate.text = "NOW"
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            postDate.text = "\(difference.minute) MINUTES AGO"
        }
        if difference.hour! > 0 && difference.day! == 0 {
            postDate.text = "\(difference.hour) HOURS AGO"
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            postDate.text = "\(difference.day) DAYS AGO"
        }
 */
        
            postDate.text = "\(formatter.string(from: dateArray.last!))"
        }
        
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentOffset = CGPoint(x: 0, y: 81)
    }
    

    
    //User cancels creating a new recipe
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        //clean up post uuid
        if !postuuid.isEmpty {
            postuuid.removeLast()
        }
        self.navigationController?.popViewController(animated: true)
    }



    

    
    
}
