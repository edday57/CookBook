//
//  NewRecipeViewController.swift
//  CookBook
//
//  Created by Edward Day on 27/08/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit

class NewRecipeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var additionalInfoSwitch: UISwitch!
    
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var instructionField: UITextField!
    @IBOutlet weak var ingredientsField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var privacyPicker: UIPickerView!
    @IBOutlet weak var additionalInfo: UITextView!
    
    var postPrivacy: [String] = ["Public", "Private"]
    
    var privacyNumber = 8
    var isPrivate = false
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Adds a white border to the gradient view
        gradientView.layer.borderWidth = 2.0
        gradientView.layer.borderColor = UIColor.white.cgColor
        
        //Adds a shadow to the gradient
        gradientView.layer.shadowOpacity = 0.4
        gradientView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        gradientView.layer.shadowRadius = 5.0
        
        
        //Setup privacy picker
        privacyPicker.dataSource = self
        privacyPicker.delegate = self
        
        additionalInfo.text = "Add any additional info here!"
        additionalInfo.textColor = UIColor.lightGray

        //Initialize text fields
        self.nameTextField.delegate = self
        self.ingredientsField.delegate = self
        self.instructionField.delegate = self
        self.additionalInfo.delegate = self
        
        //Disable save button at first
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    //Configure privacy picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return postPrivacy.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return postPrivacy[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    privacyNumber = row
        if privacyNumber == 0 {
            isPrivate = false
        }
        else if privacyNumber == 1 {
            isPrivate == true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func viewTapped(_ sender: AnyObject) {
        if additionalInfo.text.isEmpty {
            additionalInfo.text = "Add any additional info here!"
            additionalInfo.textColor = UIColor.lightGray
        
        }
        additionalInfo.resignFirstResponder()
    }
    @IBAction func additionalInfoTapped(_ sender: AnyObject) {
        if additionalInfo.textColor == UIColor.lightGray {
            additionalInfo.text = nil
            additionalInfo.textColor = UIColor.black
            additionalInfo.becomeFirstResponder()
            
        }
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if additionalInfo.textColor == UIColor.lightGray {
            additionalInfo.text = nil
            additionalInfo.textColor = UIColor.black
            additionalInfo.becomeFirstResponder()
        }
    }
    
    
    
    //Enable return keys
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
        nameTextField.resignFirstResponder()
        }
        if textField.tag == 2 {
            ingredientsField.resignFirstResponder()
        }
        if textField.tag == 3 {
            instructionField.resignFirstResponder()
        }
        return true
    }
    
    //Check to enable save button on end editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForSaveEnabled()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        checkForSaveEnabled()
    }
    
    
    //Allows user to choose an image and import it
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
        userImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        imageLabel.isHidden = true
        checkForSaveEnabled()
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
    
    

    

    
    // When the user pressed add ingredient button.
    @IBAction func addIngredient(_ sender: AnyObject) {
        if let ingredient = ingredientsField.text {
            if ingredient != "" {
                
                //If instruction text field has a value then...
                
                //If this is the first instruction then clear the text field
                if ingredientsTextView.text == "Add an ingredient!" {
                    ingredientsTextView.text = "\(ingredient)"
                    
                }
                else {
                    let currentIngredients = ingredientsTextView.text
                    ingredientsTextView.text = "\(currentIngredients!),  \(ingredient)"
                }
                //Clear the instruction text field
                ingredientsField.text = nil
                checkForSaveEnabled()
            }
        }
    }

    

    //When the user adds an instruction
    var instructionsArray = [String]()
    var instructionCount = 0
    
    @IBAction func addInstruction(_ sender: AnyObject) {
        if let instruction = instructionField.text {
            if instruction != "" {
                
                //If instruction text field has a value then...
                instructionsArray.append(instruction)
                
                //If this is the first instruction then clear the text field
                if instructionsArray.count == 1 {
                    instructionsTextView.text = "1. \(instruction)."}
                
                else {
                    instructionCount += 1
                    instructionsTextView.text.append("\n\(instructionCount + 1). \(instructionsArray[instructionCount]).")
                        
                    }
                }
                //Clear the instruction text field
                instructionField.text = nil
            checkForSaveEnabled()
            }
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if nameTextField.text != nil && userImage.image != nil && timeField.text != nil && ingredientsTextView.text != nil && ingredientsTextView.text != "Add an ingredient!" && instructionsTextView.text != nil && instructionsTextView.text != "Add an instruction!" && additionalInfo.text != nil && additionalInfo.text != "Add any additional info here!" {
            let name = nameTextField.text!
            let photo = userImage.image!
            let time = Int(timeField.text!)
            let ingredients = ingredientsTextView.text!
            let instructions = instructionsTextView.text!
            let isPrivate = self.isPrivate
            let additionalInfo = self.additionalInfo.text!
            
            recipe = Recipe(name: name, photo: photo, time: time!, ingredients: ingredients, instructions: instructions, isPrivate: isPrivate, additionalInfo: additionalInfo)
        }
    }
    
    func checkForSaveEnabled() {
        if nameTextField.text != nil && userImage.image != nil && timeField.text != nil && ingredientsTextView.text != nil && ingredientsTextView.text != "Add an ingredient!" && instructionsTextView.text != nil && instructionsTextView.text != "Add an instruction!" && additionalInfo.text != nil && additionalInfo.text != "Add any additional info here!"{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
}
