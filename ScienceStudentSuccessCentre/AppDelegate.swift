//
//  AppDelegate.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-01-19.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "includeInProgressCourses") == nil {
            defaults.set(true, forKey: "includeInProgressCourses")
        }

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard url.pathExtension == "sssc" else { return false }
        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let navigationController = tabBarController.selectedViewController as? UINavigationController,
            let viewController = navigationController.viewControllers.first else {
                return true
        }
        
        let title: String
        let message: String
        
        if Database.instance.importData(from: url) {
            if let ctrl = viewController.children.first(where: { $0 is GradesViewControllerDelegate }),
                let delegate = ctrl as? GradesViewControllerDelegate {
                delegate.refreshTableViewData()
            }
            title = "Successfully imported data!"
            message = "Your grades data was successfully imported."
        } else {
            title = "Failed to import data!"
            message = "Your grades data was not imported. Please make sure the file you are trying to import is not modified in any way from what was originally exported from the app!"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            navigationController.dismiss(animated: true, completion: nil)
        }))
        viewController.present(alert, animated: true, completion: nil)
        
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


}

