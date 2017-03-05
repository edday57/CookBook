//
//  TabBar.swift
//  CookBook
//
//  Created by Edward Day on 08/01/2017.
//  Copyright © 2017 Edward Day. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarItems = tabBar.items! as [UITabBarItem]
       // tabBarItems[1].title = nil
      //  tabBarItems[1].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        tabBarItems[0].title = nil
        tabBarItems[0].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        //tabBarItems[2].title = nil
        //tabBarItems[2].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
      //  tabBarItems[3].title = nil
      //  tabBarItems[3].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
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
