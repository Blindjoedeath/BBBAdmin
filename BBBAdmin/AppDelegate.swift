//
//  AppDelegate.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 10.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: {
            storeDescription, error in
            if let error = error {
                fatalError("Could load data store: \(error)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = self.persistentContainer.viewContext

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarController = window!.rootViewController as! UITabBarController
        if let tabBarViewControllers = tabBarController.viewControllers {
            
            let infographicsViewController = tabBarViewControllers[0] as! InfographicsViewController
            infographicsViewController.managedObjectContext = managedObjectContext
            
            let userListViewController = tabBarViewControllers[1] as! UserlistViewController
            userListViewController.managedObjectContext = managedObjectContext
        }
        
        Search.managedObjectContext = managedObjectContext
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
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
}

