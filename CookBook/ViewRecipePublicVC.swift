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

    @IBOutlet weak var uuidLabel: UILabel!
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
        recipeName.layer.shadowRadius = 4
        
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
                    self.uuidArray.append(object.value(forKey: "uuid")as! String)
                    self.uuidLabel.text = self.uuidArray.last
                    self.additionalInfoEnabledArray.append(object.value(forKey: "additionalInfoEnabled")as! Int)
                    if self.additionalInfoEnabledArray.last == 1 {
                        self.additionalInfoView.text = (object.value(forKey: "additionalInfo") as! String)
                        self.containerHeight.constant = 900
                    } else {
                        self.containerHeight.constant = 750
                        self.additionalInfoView.isHidden = true
                        self.additionalInfoLabel.isHidden = true
                    }

                    

                    let pictureFile = object.value(forKey: "picture") as! PFFile
                    pictureFile.getDataInBackground(block: { (data:Data?, error:Error?) in
                        if error == nil {
                            self.userImage.image = UIImage(data: data!)
                        }
                    })
                    self.dateArray.append(object.createdAt!)
                    self.calculateDate(self.dateArray.last!)
                    
                    
                }
                let avaQuery = PFUser.query()
                avaQuery?.whereKey("username", equalTo: self.postUsername.text!)
                avaQuery?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                    if error == nil {
                        for object in objects! {
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
            

        }
 
        //show like button depending on whether it is liked or not
        let didLike = PFQuery(className: "likes")
        didLike.whereKey("by", equalTo: PFUser.current()!.username!)
        didLike.whereKey("to", equalTo: postuuid.last!)
        didLike.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                if count == 1 {
                    self.likeButton.image = UIImage(named: "liked")
                } else {
                    self.likeButton.image = UIImage(named: "unliked")
                    
                }
            }
        }
        
        let likeCount = PFQuery(className: "likes")
        likeCount.whereKey("to", equalTo: postuuid.last!)
        likeCount.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                self.likeCount.text = String(count)
            }
        }
        
        //double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: "likeTap")
        likeTap.numberOfTapsRequired = 2
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(likeTap)

        
        
        }
    
    func likeTap() {
        
        //create large like heart
        let likePic = UIImageView(image: UIImage(named: "unlike"))
        likePic.frame.size.width = userImage.frame.size.height / 1.5
        likePic.frame.size.height = userImage.frame.size.height / 1.5
       // likePic.center = userImage.center

        
        likePic.center = CGPoint(x: userImage.center.x, y: userImage.center.y - 70)
        likePic.alpha = 0.9
        userImage.addSubview(likePic)
        
        //hide likePic with animation and transform
        UIView.animate(withDuration: 0.6) {
            likePic.alpha = 0
            likePic.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        if likeButton.image == UIImage(named: "unliked") {
            let object = PFObject(className: "likes")
            object["by"] = PFUser.current()!.username!
            object["to"] = postuuid.last!
            
            object.saveInBackground(block: { (success:Bool, error:Error?) in
                if success {
                    self.likeButton.image = UIImage(named: "liked")
                    self.likeCount.text = String(Int(self.likeCount.text!)! + 1)
                } else {
                    print(error!.localizedDescription)
                }
            })
            
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
        
    @IBAction func likeButtonTapped(_ sender: AnyObject) {
        //If the user hasnt liked it then like it!
        if likeButton.image == UIImage(named: "unliked") {
            
            let object = PFObject(className: "likes")
            object["by"] = PFUser.current()!.username!
            object["to"] = postuuid.last!
            
            object.saveInBackground(block: { (success:Bool, error:Error?) in
                if success {
                    self.likeButton.image = UIImage(named: "liked")
                    self.likeCount.text = String(Int(self.likeCount.text!)! + 1)
                } else {
                    print(error!.localizedDescription)
                }
            })
        } else {
            let query = PFQuery(className: "likes")
            query.whereKey("by", equalTo: PFUser.current()!.username!)
            query.whereKey("to", equalTo: postuuid.last!)
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackground(block: { (success:Bool, error:Error?) in
                            if success {
                                self.likeButton.image = UIImage(named: "unliked")
                                self.likeCount.text = String(Int(self.likeCount.text!)! - 1)
                            }
                        })
                    }
                }
            })
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentOffset = CGPoint(x: 0, y: 81)
        avaImage.layer.cornerRadius = avaImage.frame.width / 2
        avaImage.layer.masksToBounds = true
        avaImage.layer.borderWidth = 1
        avaImage.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func usernameTapped(_ sender: AnyObject) {
        if postUsername.text == PFUser.current()!.username! {
            //If it is users own post then go home
            let home = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as! ProfileVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            //If user is someone elses post then go to their page
            guestname.append(postUsername!.text!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! GuestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
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
