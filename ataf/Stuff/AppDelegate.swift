//
//  AppDelegate.swift
//  ataf
//
//  Created by ned on 05/03/2018.
//  Copyright © 2018 ned. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor = purple
        UINavigationBar.appearance().tintColor = UIColor.white

        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if let nav = self.window?.rootViewController as? UINavigationController {
            if let c: Main = nav.viewControllers[0] as? Main, let index = Int(shortcutItem.type) {
                c.performShortcutSegue(index)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }


}

