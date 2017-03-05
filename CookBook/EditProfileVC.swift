//
//  EditProfileVC.swift
//  CookBook
//
//  Created by Edward Day on 07/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse

class EditProfileVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var aboutTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var fullnameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    
    @IBOutlet weak var changeAvaBtn: UIButton!
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var darkModeSlider: UISwitch!

    
        //picker view and picker data
        var genderPicker : UIPickerView!
        let genders = ["Male","Female"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        darkModeSlider.isOn = defaults.bool(forKey: "darkMode")
        // Do any additional setup after loading the view.
        avaImg.layer.borderWidth = 1
        avaImg.layer.borderColor = UIColor.gray.cgColor
        
        avaImg.layer.cornerRadius = 40
        avaImg.clipsToBounds = true
        
        //create picker
        genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackground
        genderPicker.showsSelectionIndicator = true
        genderTxt.inputView = genderPicker
        
        //tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(EditProfileVC.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //get information
        information()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeCoverBtnTapped(_ sender: AnyObject) {

    }
    //user info function
    func information() {
        
        //profile pic
        let ava = PFUser.current()?.object(forKey: "ava") as! PFFile
        ava.getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                self.avaImg.image = UIImage(data: data!)
            }
        }
        
        //text info
        usernameTxt.text = PFUser.current()?.username
        fullnameTxt.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.capitalized
        aboutTxt.text = PFUser.current()?.object(forKey: "about") as? String
        emailTxt.text = PFUser.current()?.email
        phoneTxt.text = PFUser.current()?.object(forKey: "phone") as? String
        genderTxt.text = PFUser.current()?.object(forKey: "gender") as? String
    }
    
    func validateEmail(email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{2}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
        let range = email.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    func alert (error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func saveBtnClicked(_ sender: AnyObject) {
        //if incorrect email then give error
        if !validateEmail(email: emailTxt.text!) {
            alert(error: "Invalid email", message: "Please enter the correct email!")
            return
        }
        
        //save filled in info
        let user = PFUser.current()!
        if usernameTxt.text != nil {
            if usernameTxt.text != "" {
        user.username = usernameTxt.text?.lowercased()
            }
        }
        if emailTxt.text != user.email {
            if emailTxt.text != nil {
                if emailTxt.text != "" {
        user.email = emailTxt.text?.lowercased()
                }
            }
        }
        if fullnameTxt.text != nil {
            if fullnameTxt.text != "" {
        user["fullname"] = fullnameTxt.text?.lowercased()
            }
        }
        if aboutTxt.text != nil {
            if aboutTxt.text != "" {
        user["about"] = aboutTxt.text
            }
        }
        if phoneTxt.text!.isEmpty {
            user["phone"] = ""
        } else {
            user["phone"] = phoneTxt.text
        }
        
        if genderTxt.text!.isEmpty {
            user["gender"] = ""
        } else {
            user["gender"] = genderTxt.text
        }
        
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        user.saveInBackground { (success:Bool, error:Error?) in
            if success { self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func changePhotoBtnClicked(_ sender: AnyObject) {
    }
    
    //PICKER VIEW METHODS
    //number of items
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxt.text = genders[row]
        self.view.endEditing(true)
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
        let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        avaImg.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func logOutTapped(_ sender: Any) {
        PFUser.logOutInBackground { (error:Error?) in
            if error == nil {
                
                //Remove saved login info
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
                
                let signin = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! LoginViewController
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController =  signin
            }
        }

    }
    @IBAction func darkModeSliderChanged(_ sender: Any) {
        let defaults = UserDefaults.standard

        if darkModeSlider.isOn {
            defaults.set(true, forKey: "darkMode")
        } else {
            defaults.set(false, forKey: "darkMode")
        }
    }
    //////////////////////////////////////////////////////////////////////////////

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
