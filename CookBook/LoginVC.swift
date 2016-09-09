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

extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case Unknown
    }
    var screenType: ScreenType? {
        guard iPhone else { return nil }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return nil
        }
    }
    
    // helper funcs
    static func isScreen35inch() -> Bool {
        return UIDevice().screenType == .iPhone4
    }
    
    static func isScreen4inch() -> Bool {
        return UIDevice().screenType == .iPhone5
    }
    
    static func isScreen47inch() -> Bool {
        return UIDevice().screenType == .iPhone6
    }
    
    static func isScreen55inch() -> Bool {
        return UIDevice().screenType == .iPhone6Plus
    }}
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
    
    //other
    @IBOutlet weak var usernameImage: UIImageView!
    @IBOutlet weak var loginTopSpacing: NSLayoutConstraint!

    
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
        if UIDevice.isScreen35inch() {
            loginTopSpacing.constant = 25
        } else if UIDevice.isScreen4inch(){
            loginTopSpacing.constant = 35
        }
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

