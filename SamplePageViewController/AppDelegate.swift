//
//  AppDelegate.swift
//  SamplePageViewController
//
//  Created by David Rynn on 7/15/19.
//  Copyright © 2019 David Rynn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller1 = SampleViewController()
        controller1.view.backgroundColor = #colorLiteral(red: 0.9555206895, green: 0.9556805491, blue: 0.9554995894, alpha: 1)
        let controller2 = SampleTextViewController()
        controller2.view.backgroundColor = #colorLiteral(red: 0.8806003928, green: 0.9414284229, blue: 0.9402227402, alpha: 1)
        let controller3 = SampleViewController()
        controller3.view.backgroundColor = #colorLiteral(red: 0.9555206895, green: 0.9556805491, blue: 0.9554995894, alpha: 1)
        let controller4 = SampleTextInputViewController()
        controller4.view.backgroundColor = #colorLiteral(red: 0.8806003928, green: 0.9414284229, blue: 0.9402227402, alpha: 1)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let listener = SamplePageInteractor()
        let root = SamplePageContainerViewController([controller1, controller2, controller3, controller4], listener: listener)
        listener.presenter = root
        let rootNav = UINavigationController(rootViewController: root)
        rootNav.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = rootNav
        window?.makeKeyAndVisible()
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

