//
//  ViewController.swift
//  CookBook
//
//  Created by Edward Day on 25/08/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse

////////////////////////////////////////////////////////////////////////




class LoginViewController: UIViewController, UITextFieldDelegate {
   
    //OUTLETS
    
    //text fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    //buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    


    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view, typically from a nib.
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)

        }

    //Set up screen spacing
    override func viewDidAppear(_ animated: Bool) {

    }
 
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        //hide keyboard
        self.view.endEditing(true)
        
        //if text fields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            let alert = UIAlertController(title: "Error", message: "No username or password entered.", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        else { PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!, block: { (user:PFUser?, error:Error?) in
            //if the login has no error then...
            if error == nil {
                //remember user
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
            
                //call appdelegate login function
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
            } else {
                
                //SHOW alert message
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                

            }
        })
        }
    }

    
    //Allow keyboards to be dismissed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
}

