//
//  AppDelegate.swift
//  OneDance
//
//  Created by Burak Can on 7/1/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit
import CoreData
import AWSS3

import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator : AppCoordinator!
    fileprivate let GOOGLE_MAPS_API_KEY = "AIzaSyChg0cMEnb0xK0DbTqImDeIKkha6N84HJI"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Colors (SWIFT 3)
        UINavigationBar.appearance().barTintColor = UIColor(red: 44.0/255.0, green: 43.0/255.0, blue: 64.0/255.0, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        /*
         //SWIFT 4
         UINavigationBar.appearance().barTintColor = .black
         UINavigationBar.appearance().tintColor = .white
         UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
         UINavigationBar.appearance().isTranslucent = false
         
         */
        
        // Tabbar colors
        UITabBar.appearance().tintColor = UIColor(red: 44.0/255.0, green: 43.0/255.0, blue: 64.0/255.0, alpha: 1)
        
        // Device
        if !PersistanceManager.User.isLoggedIn {
            ShineNetworkService.API.User.addDevice()
        }
        
        // Google maps
        //GMSServices.provideAPIKey(GOOGLE_MAPS_API_KEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_MAPS_API_KEY)
        
        // AWS configuration
        ShineNetworkService.S3.configureAWS()
        
        // Status bar setting
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Configure app coordinator
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
        
        //configureViews()
        
        /*
        let vc = LoginViewController(nibName: "LoginViewController", bundle: nil);
        window!.rootViewController = vc
        */
        window!.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    func configureViews() {
                
        let homeViewController = UITabBarController()
        
        // Create the corresponding controllers
        
        // Timeline
        let timeLineVC = UIViewController()
        let timelineNavigationVC = UINavigationController(rootViewController: timeLineVC)
        let timelineTabrBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "converter-tabbar.png"), tag: 2)
        timelineNavigationVC.tabBarItem = timelineTabrBarItem
        
        // Map - Search
        let mapSearchViewController = MapViewController(nibName: "MapViewController", bundle: nil)
        let mapSearchNavigationController = UINavigationController(rootViewController: mapSearchViewController)
        let mapSearchTabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "converter-tabbar.png"), tag: 2)
        mapSearchNavigationController.tabBarItem = mapSearchTabBarItem
        
        // Profile
        let profileVC = UIViewController()
        let profileNavigationVC = UINavigationController(rootViewController: profileVC)
        let profileTabrBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "converter-tabbar.png"), tag: 3)
        profileNavigationVC.tabBarItem = profileTabrBarItem
        
        homeViewController.viewControllers = [timelineNavigationVC, mapSearchNavigationController, profileNavigationVC]
        window!.rootViewController = homeViewController
        
    
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "OneDance")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

