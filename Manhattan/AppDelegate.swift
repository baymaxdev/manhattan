//
//  AppDelegate.swift
//  Manhattan
//
//  Created by gOd on 7/21/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import FacebookCore
import NVActivityIndicatorView
import Firebase
import AWSS3
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var user: User?
    var curUserId: Int = 0
    var indicator: NVActivityIndicatorView?
    var indicatorView: UIView?
    var tabBarController: TabBarViewController?

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        /*
         Store the completion handler.
         */
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: (window?.frame.width)!, height: (window?.frame.height)!))
        indicator = NVActivityIndicatorView(frame: CGRect.init(x: (indicatorView?.frame.width)!/2 - 50.0, y: (indicatorView?.frame.height)!/2 - 50.0, width: 100, height: 100), type: NVActivityIndicatorType.ballSpinFadeLoader, color: UIColor.white, padding: 0)
        indicatorView?.addSubview(indicator!)
        indicatorView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navigation")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        UINavigationBar.appearance().isTranslucent = false
        
        STPPaymentConfiguration.shared().publishableKey = STRIPEKEY
        
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func isMe() -> Bool {
        if curUserId == user?.id {
            return true
        }
        else {
            return false
        }
    }
    
    func configureTabBar() {
        tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarViewController
        self.window?.rootViewController = tabBarController
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func showAlert(vc: UIViewController, msg: String, action: UIAlertAction?) {
        let alert = UIAlertController(title: "Manhattan", message: msg, preferredStyle: .alert)
        if action == nil {
            let act = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(act)
        }
        else {
            alert.addAction(action!)
        }
        vc.present(alert, animated: true, completion: nil)
    }

    func showLoader(vc: UIViewController) {
        vc.view.addSubview(indicatorView!)
        indicator?.startAnimating()
    }
    
    func showLoader(vc: UIViewController, withMessage message: String) {
        self.showLoader(vc: vc, withMessage: "Loading...")
    }
    
    func hideLoader() {
        indicator?.stopAnimating()
        indicatorView?.removeFromSuperview()
    }
    
    func getFileName(type: String) -> String {
        var str = type + "_\(Date.timeIntervalSinceReferenceDate * 1000)"
        if type == "video" {
            str += ".mp4"
        } else {
            str += ".jpg"
        }
        
        return str
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

