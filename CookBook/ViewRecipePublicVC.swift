//
//  ViewRecipeViewController.swift
//  CookBook
//
//  Created by Edward Day on 27/08/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse


//var postuuid = [String]()

class ViewRecipePublicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate{
    
    let darkBlack = UIColor(colorLiteralRed: 65/255, green: 65/255, blue: 65/255, alpha: 1.0)
    let recipeTextColor = UIColor(colorLiteralRed: 231/255, green: 148/255, blue: 61/255, alpha: 1.0)
    let infoTextColor = UIColor(colorLiteralRed: 237/255, green: 103/255, blue: 55/255, alpha: 1.0)
    var selectedSegment: Int = 1
    //Server arrays
    var avaArray = [PFFile]()
    var usernameArray = [String]()
    var dateArray = [Date]()
    
    var picArray = [PFFile]()
    var titleArray = [String]()
    var additionalInfoEnabledArray = [Int]()
    var uuidArray = [String]()
    
    @IBOutlet weak var containerView1: UIView!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var postUsername: UILabel!
    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    
    //RECIPE OUTLETS

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!


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
                self.additionalInfoEnabledArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    //self.titleArray.append(object.value(forKey: "title")as! String)
                    //  self.recipeName.text = self.titleArray.last
                    self.recipeName.text = (object.value(forKey: "title") as! String)

                    self.postUsername.text = (object.value(forKey: "username")as! String)
                    self.uuidArray.append(object.value(forKey: "uuid")as! String)
                    self.uuidLabel.text = self.uuidArray.last
                    self.additionalInfoEnabledArray.append(object.value(forKey: "additionalInfoEnabled")as! Int)
                    if self.additionalInfoEnabledArray.last == 1 {
                        self.containerHeight.constant = 950
                    } else {
                        self.containerHeight.constant = 800

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
        
        updateSection()
        }
    /*
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
    */
    
    func calculateDate(_ date: Date) {

        let formatter = DateFormatter()
       formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.none

        
            postDate.text = "\(formatter.string(from: dateArray.last!))"
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

    @IBOutlet weak var recipeBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    
    @IBAction func recipeBtnTapped(_ sender: AnyObject) {
        let newSelection = sender.tag
        if newSelection == selectedSegment {
            return
        }
        else {
            selectedSegment = newSelection!
            updateSection()
        }
    }
    
    func updateSection() {
        if selectedSegment == 1 {
            infoBtn.setTitleColor(infoTextColor, for: UIControlState.normal)
            recipeBtn.setTitleColor(darkBlack, for: UIControlState.normal)
            //hide recipe, unhide info, reload info
            containerView1.isHidden = true
        }
        else if selectedSegment == 2 {
            recipeBtn.setTitleColor(recipeTextColor, for: UIControlState.normal)
            infoBtn.setTitleColor(darkBlack, for: UIControlState.normal)
            //hide info, reload recipe, unhide recipe
            containerView1.reloadInputViews()
            containerView1.isHidden = false
        }
    }

    @IBAction func infoBtnTapped(_ sender: AnyObject) {
    }

    
    

    
    
}
