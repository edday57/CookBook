//
//  ProfileVC.swift
//  CookBook
//
//  Created by Edward Day on 04/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse



class ProfileVC: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! ProfileHeaderView
        
        //Configure the nav bar
        header.navBar.setBackgroundImage(UIImage(), for: .default)
        header.navBar.shadowImage = UIImage()
        header.navBar.isTranslucent = true
        let attrs = [
            NSForegroundColorAttributeName : UIColor.white,
            //   NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 24)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        header.navTitle.title = PFUser.current()!.username!.uppercased()
        
        
        //Get user data and set labels
        header.fullnameLbl.text = (PFUser.current()!.object(forKey: "fullname") as? String)?.capitalized
        header.aboutLbl.text = PFUser.current()!.object(forKey: "about") as? String
        header.usernameLbl.text = "@\(PFUser.current()!.username!)"
        header.button.setTitle("Edit Profile", for: UIControlState.normal)
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {header.avaImg.image = UIImage(data: data!)
            }
        }
        
        return header
    }

    /*
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
 */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
