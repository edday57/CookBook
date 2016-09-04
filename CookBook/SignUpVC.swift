//
//  SignUpViewController.swift
//  CookBook
//
//  Created by Edward Day on 03/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
   ////////////////////////////////////////
    //Outlets
    
    //user img
    @IBOutlet weak var userImg: UIImageView!
    
    //text fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var aboutTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    //buttons
    @IBOutlet weak var signUpButton: UIButton!
    
    //other outlets
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var alertTxt: UILabel!
    //////////////////////////////////////
    
    
    
    
    
    ///////////////////////////////////////
    //ViewDidLoad - Initial Configuration
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Configure user image
        userImg.layer.cornerRadius = 54
        userImg.layer.masksToBounds = true
        userImg.layer.borderWidth = 3
        userImg.layer.borderColor = UIColor.white.cgColor
        
        //Configure sign up button
        let buttonOrange = signUpButton.currentTitleColor
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = buttonOrange.cgColor
        signUpButton.layer.shadowOpacity = 0.3
        signUpButton.layer.shadowOffset = CGSize(width: 1, height: 4)
        signUpButton.layer.shadowRadius = 4
        
        //Add an upwards shadow from the bottom view
        BottomView.layer.shadowOpacity = 0.3
        BottomView.layer.shadowRadius = 7
        BottomView.layer.shadowOffset = CGSize(width: 0, height: -3)
        
        //Configure text field delegates
        self.usernameTxt.delegate = self
        self.passwordTxt.delegate = self
        self.repeatPasswordTxt.delegate = self
        self.emailTxt.delegate = self
        self.aboutTxt.delegate = self
        self.fullnameTxt.delegate = self

    }

    ///////////////////////////////////////
    
    @IBAction func signUpBtnTapped(_ sender: AnyObject) {
        
        //dismiss keyboard
        self.view.endEditing(true)
        
        //if a field is empty then alert the user
        if (usernameTxt.text!.isEmpty ||  passwordTxt.text!.isEmpty || repeatPasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || aboutTxt.text!.isEmpty) {
            
            alertTxt.text = "Please fill all fields."
            
        }
        
        //if passwords dont match then alert the user
        else if passwordTxt.text != repeatPasswordTxt.text {
            
            alertTxt.text = "Passwords do not match!"
        }
        
        let user = PFUser()
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user.password = passwordTxt.text
        user["fullname"] = fullnameTxt.text?.lowercased()
        user["about"] = aboutTxt.text
        
        //Will be avaliable in edit profile
        user["phone"] = ""
        user["gender"] = ""
        
        //convert image for sending to server
        let avaData = UIImageJPEGRepresentation(userImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        user.signUpInBackground { (success:Bool, error:Error?) in
            if success {
                print("registered")
                
                //remember logged user
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                //call login function from app delegate
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
            } else {
                
                //SHOW alert message
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
        
    }

    
    
    
    //Hide keyboard when user presses done key
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Hide all keyboards
        self.view.endEditing(true)
        return true
    }
    
    

    //////////////////////////////////////////////////////////////////////////////
    //Allows user to pick a profile photo, set it as the current image, and allows it to be editted.
    
    let picker = UIImagePickerController()

    @IBAction func addImageTapped(_ sender: UITapGestureRecognizer) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.view.tintColor = UIColor.orange
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        picker.delegate = self
        picker.allowsEditing = true
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Warning", message: "You don't have a camera", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        userImg.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)

    }
    //////////////////////////////////////////////////////////////////////////////
    
    
    
    
    //Dismiss the view when user presses the cancel button
     @IBAction func cancelBtnTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
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
