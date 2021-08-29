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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Features.fetch()
        processLaunchArguments()
        UNUserNotificationCenter.current().delegate = self
        
        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let splitViewController = tabBarController.viewControllers?.first as? UISplitViewController
            else { fatalError() }
        splitViewController.preferredDisplayMode = .allVisible
        
        return true
    }
    
    /// Used to prepare the environment in the case of launch variables. Should only be used for testing, App Store screenshots, etc.
    ///
    /// Current valid arguments:
    /// - `UseTestGradeData` (automatically imports some test data, overwriting what is already there)
    /// - `HideTestEvents` (hides the test events that are automatically added when compiling for debugging)
    /// - `CleanStatusBar` (sets the simulator battery to full, changes the time to 9:41 am, and sets wifi/cellular to full signal)
    func processLaunchArguments() {
        let arguments = ProcessInfo.processInfo.arguments
        
        if arguments.contains("UseTestGradeData"), let url = Bundle.main.url(forResource: "TestGradeData", withExtension: "sssc") {
            _ = Database.instance.importData(from: url)
        }
        
        LocalSavedData.showTestEvents = !arguments.contains("HideTestEvents")
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        guard let tabBarController = window?.rootViewController as? UITabBarController else { fatalError() }
        switch shortcutItem.type {
        case "com.carleton.sciencestudentsuccesscentre.events":
            tabBarController.selectedIndex = 0
        case "com.carleton.sciencestudentsuccesscentre.grades":
            tabBarController.selectedIndex = 1
        case "com.carleton.sciencestudentsuccesscentre.mentoring":
            tabBarController.selectedIndex = 2
        case "com.carleton.sciencestudentsuccesscentre.resources":
            tabBarController.selectedIndex = 3
        default: break
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        guard url.pathExtension == "sssc" else { return false }
        guard let tabBarController = window?.rootViewController as? UITabBarController else { return true }
        tabBarController.selectedIndex = 1
        
        guard let navigationController = tabBarController.selectedViewController as? UINavigationController,
            let viewController = navigationController.viewControllers.first else {
                return true
        }
        
        if Database.instance.importData(from: url) {
            if let ctrl = viewController.children.first(where: { $0 is GradesViewControllerDelegate }),
                let delegate = ctrl as? GradesViewControllerDelegate {
                delegate.refreshTableViewData()
            }
            viewController.presentAlert(kind: .importSuccess)
        } else {
            viewController.presentAlert(kind: .importError)
        }
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let tabBarController = window?.rootViewController as? UITabBarController else { return }
        tabBarController.selectedIndex = 0
        
        guard let splitViewController = tabBarController.selectedViewController as? UISplitViewController else { return }
        guard let eventsNavController = splitViewController.viewControllers.first as? UINavigationController else { return }
        guard let eventsViewController = eventsNavController.viewControllers.first as? EventsViewController else { return }
        
        let deepLinkId = response.notification.request.identifier
        if let detailNavController = eventsNavController.viewControllers.last as? UINavigationController,
            let detailViewController = detailNavController.viewControllers.first as? EventDetailViewController {
            if detailViewController.event?.id == deepLinkId {
                detailViewController.refreshUI()
                completionHandler()
                return
            }
        }
        
        if eventsViewController.events.count == 0 {
            // We wait for the events to load before re-enabling interactions, so the user doesn't navigate away before we finish the deeplink.
            tabBarController.view.isUserInteractionEnabled = false
            eventsViewController.loadEvents(deepLinkId: deepLinkId) {
                // Re-enable user interaction and navigate to the deeplink.
                tabBarController.view.isUserInteractionEnabled = true
            }
        } else {
            eventsViewController.navigateToDeepLinkId(deepLinkId)
        }
        completionHandler()
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
