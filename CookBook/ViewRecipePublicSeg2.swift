//
//  ViewRecipePublicSeg2.swift
//  CookBook
//
//  Created by Edward Day on 27/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse

class ViewRecipePublicSeg2: UIViewController {

    //Server Arrays
    var timeArray = [Int]()
    var instructionsArray = [String]()
    var ingredientsArray = [String]()
    var additionalInfoArray = [String]()
    var additionalInfoEnabledArray = [Int]()
    
    //Time Outlets
    @IBOutlet weak var timeBtn: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    
    //Like Outlets
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    //Text Views
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var additionalInfoTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                
                //Clean up
                self.timeArray.removeAll(keepingCapacity: false)
                self.ingredientsArray.removeAll(keepingCapacity: false)
                self.instructionsArray.removeAll(keepingCapacity: false)
                self.additionalInfoArray.removeAll(keepingCapacity: false)
                self.additionalInfoEnabledArray.removeAll(keepingCapacity: false)

                for object in objects! {
                    self.timeLabel.text = "\((object.value(forKey: "time") as! Int)) mins"
                    self.ingredientsTextView.text = "Ingredients: \((object.value(forKey: "ingredients") as! String))"
                    self.instructionsTextView.text = (object.value(forKey: "instructions")as! String)
                    self.additionalInfoEnabledArray.append(object.value(forKey: "additionalInfoEnabled")as! Int)
                    if self.additionalInfoEnabledArray.last == 1 {
                        self.additionalInfoTextView.text = (object.value(forKey: "additionalInfo") as! String)
                       
                    } else {

                        self.additionalInfoTextView.isHidden = true
                        self.additionalInfoLabel.isHidden = true
                    }

                }
                
            }
        }
        //show like button depending on whether it is liked or not
        let didLike = PFQuery(className: "likes")
        didLike.whereKey("by", equalTo: PFUser.current()!.username!)
        didLike.whereKey("to", equalTo: postuuid.last!)
        didLike.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                if count == 1 {
                    self.likeImg.image = UIImage(named: "liked")
                } else {
                    self.likeImg.image = UIImage(named: "unliked")
                    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func likeButtonTapped(_ sender: AnyObject) {
        //If the user hasnt liked it then like it!
        if likeImg.image == UIImage(named: "unliked") {
            
            let object = PFObject(className: "likes")
            object["by"] = PFUser.current()!.username!
            object["to"] = postuuid.last!
            
            object.saveInBackground(block: { (success:Bool, error:Error?) in
                if success {
                    self.likeImg.image = UIImage(named: "liked")
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
                                self.likeImg.image = UIImage(named: "unliked")
                                self.likeCount.text = String(Int(self.likeCount.text!)! - 1)
                            }
                        })
                    }
                }
            })
        }
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
