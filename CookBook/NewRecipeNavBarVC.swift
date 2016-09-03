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

        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
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
