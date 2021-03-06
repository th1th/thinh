//
//  AppDelegate.swift
//  Thinh
//
//  Created by Tran Quang Dat on 3/11/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleMaps
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // init google map
        GMSServices.provideAPIKey("AIzaSyBl4ZXN-bBzbD0KrvZeCOjaCiRFFoZr9EY")
        GMSPlacesClient.provideAPIKey("AIzaSyBl4ZXN-bBzbD0KrvZeCOjaCiRFFoZr9EY")
        
        // init firebase
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "didLogOut"), object: nil, queue: OperationQueue.main){ (Notification) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }
        
        // get current user to and store through the app
        
        // TODO: Move thí shit after login
//        _ = Api.shared().getCurrentUser().subscribe(onNext: { (user) in
//            User.currentUser = user
//        }, onError: { (error) in
//            print(error.localizedDescription)
//        }, onCompleted: { 
//            print("Get current user")
//        }, onDisposed: nil)
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Api.shared().updateUserStatus(false)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Api.shared().updateUserStatus(true)
    }



    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       Api.shared().updateUserStatus(false)
       Api.shared().stop() 
    }
    func applicationDidBecomeActive(application: UIApplication) {
        // Call the 'activate' method to log an app event for use
        // in analytics and advertising reporting.
        FBSDKAppEvents.activateApp()
        // ...
    }
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL!,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation]
        )
    }
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }

}



