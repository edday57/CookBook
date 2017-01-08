//
//  TransNavigationViewController.swift
//  CookBook
//
//  Created by Edward Day on 07/01/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit

class TransNavigationViewController: UINavigationController {


    override func viewDidLoad() {
        super.viewDidLoad()
        let attrs = [
            NSForegroundColorAttributeName : UIColor.black,
               NSFontAttributeName : UIFont(name: "HelveticaNeue-Thin", size: 18)!
        ]

        UINavigationBar.appearance().titleTextAttributes = attrs
        self.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.navigationBar.layer.shadowRadius = 4
        self.navigationBar.layer.shadowOpacity = 0.3
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
