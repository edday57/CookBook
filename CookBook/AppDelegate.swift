//
//  AppDelegate.swift
//  CookBook
//
//  Created by Edward Day on 25/08/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
             // Override point for customization after application launch.
        
        Parse.enableLocalDatastore()
        
        //Parse configuration
        let configuration = ParseClientConfiguration {
            $0.applicationId = "oi98OHS4K8S0qq0mFrabNv7f7VVnQnxWdiWdS6Sa"
            $0.clientKey = "UZDXgrsgfZ3fiSI8rkbhrN2QX7Ajh8loyhqJyWPe"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        
        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
        
        login()
        
        UIApplication.shared.statusBarStyle = .lightContent

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func login() {
        
        //recall users login
        let username: String? = UserDefaults.standard.string(forKey: "username")
        
        //if logged in
        if username != nil {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeView = storyboard.instantiateViewController(withIdentifier: "homeView")
            window?.rootViewController = homeView
        }
    }


}

