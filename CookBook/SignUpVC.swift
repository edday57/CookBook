//
//  SignUpViewController.swift
//  CookBook
//
//  Created by Edward Day on 03/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var BottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userImg.layer.cornerRadius = 54
        userImg.layer.masksToBounds = true
        
        let buttonOrange = signUpButton.currentTitleColor
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = buttonOrange.cgColor
        signUpButton.layer.shadowOpacity = 0.3
        signUpButton.layer.shadowOffset = CGSize(width: 1, height: 4)
        signUpButton.layer.shadowRadius = 4
        BottomView.layer.shadowOpacity = 0.3
        BottomView.layer.shadowRadius = 7
        BottomView.layer.shadowOffset = CGSize(width: 0, height: -3)
        userImg.layer.borderWidth = 3
        userImg.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
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
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButton(withTitle: "OK")
            alert.show()
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
    
    
    
    
    
    
    //User cancels creating a new recipe
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Are you sure you want to discard changes?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.view.tintColor = UIColor.orange
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
        }
        let discardAction = UIAlertAction(title: "Discard Changes", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.discardChanges()
            print("Discarded")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(discardAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    func discardChanges() {
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
