//
//  ResetPassViewController.swift
//  CookBook
//
//  Created by Edward Day on 03/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse

class ResetPassViewController: UIViewController {

    //buttons
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    //text field
    @IBOutlet weak var emailTxt: UITextField!
    
    
    @IBAction func resetBtnClicked(_ sender: AnyObject) {
     
        //hide keyboard
        self.view.endEditing(true)
        
        //show alert if email text field is empty
        if emailTxt.text!.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Please enter your email.", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
            
            PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!, block: { (success:Bool, error:Error?) in
                if success {
                    
                    //show alert message
                    let alert = UIAlertController(title: nil, message: "An email has been sent with instructions to reset your password!", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else {
                    let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            })
            
        }
        
        
        
    }
    
    //cancel button is tapped
    @IBAction func cancelBtnClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
