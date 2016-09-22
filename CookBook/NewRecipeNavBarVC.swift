//
//  NewRecipeNavBarVC.swift
//  CookBook
//
//  Created by Edward Day on 28/08/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit

class NewRecipeNavBarVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let navBarbackground = UIImage(named: "NavBarLarge")
       self.navigationBar.setBackgroundImage(navBarbackground, for: UIBarMetrics.default)
        
        self.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.navigationBar.layer.shadowRadius = 4
        self.navigationBar.layer.shadowOpacity = 0.5
        
        
        //self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = false
        let attrs = [
            NSForegroundColorAttributeName : UIColor.white,
            //   NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 24)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        
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
