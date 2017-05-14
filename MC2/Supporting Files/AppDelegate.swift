//
//  AppDelegate.swift
//  MC2
//
//  Created by Adriano Soares on 04/06/15.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UnityAds.sharedInstance().setTestMode(true)        
        UnityAds.sharedInstance().start(withGameId: "1069581", andViewController: self.window?.rootViewController)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable: Any]?, reply: (@escaping ([AnyHashable: Any]?) -> Void)) {
        /*
        if(((userInfo as? NSDictionary)!.valueForKey("action") as! String) == "getBestScores"){
            reply(["bestScore" : NSUserDefaults.standardUserDefaults().integerForKey("BestScore")]);
        }else{
            reply(["bestScore" : 0]);
        }
        */
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        GameCenterManager.gcManager.reportScore(GameManager.sharedInstance.score);
        UserDefaults.standard.set(GameManager.sharedInstance.score, forKey: "BestScore");
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

