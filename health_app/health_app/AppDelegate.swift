
//
//  AppDelegate.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/12/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit
import WatchConnectivity
import HealthKit
import CloudKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    let healthStore = HKHealthStore()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.statusBarStyle = UIStatusBarStyle.lightContent
        
        if WCSession.isSupported() {
            let wcSession = WCSession.default()
            wcSession.delegate = self
            wcSession.activate()
        }
        
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // authorization from watch
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        
        
        let typesToRead = Set([
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            
            ])
        
        self.healthStore.requestAuthorization(toShare: Set([HKObjectType.workoutType()]), read: typesToRead) { (sucess, error) in
            if error != nil {
                print("MERDA NA REQUEST\n")
                print(error?.localizedDescription)
            } else {
                print(sucess)
            }
        }
        
        self.healthStore.handleAuthorizationForExtension { (sucess, error) in
            
            
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?) {
        if error != nil {
            print(error)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("\n\n*************************       AGORA TO RECEBENDO A MESSAGEM        ***************************\n\n")
        
        if message["fall"] as! String == "Detected" {
            
            // manda pro cloud
            
            print("Recebi \(message["fall"])")
            
        } else {
            print("\n\n\n\n\n*************************       TA BUGADO       ***************************\n\n\n\n\n")
        }
        
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject] = [:]) {
        print("\n\n*************************       AGORA TO RECEBENDO A INFO       ***************************\n\n")
        
        if userInfo["fall"] as! String == "Detected"{
            
            // manda pro cloud
            
            print("Recebi \(userInfo["fall"])\n\n")
            
        } else {
            print("MENTIRA!!!\n\n")
        }
    }
}

