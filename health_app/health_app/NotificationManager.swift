//
//  NotificationManager.swift
//  health_app
//
//  Created by Gabriel Bendia on 7/26/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject {
    
    func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            if granted {
                print(granted)
            } else {
                print(error)
            }
        })
    }
    
    func setupAndGenerateLocalHighHeartRateNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Aviso!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Batimnto cardíaco muito alto!", arguments: nil)
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "myNotificationCategory"
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FallNotification", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request)
        
    }
    
    func setupAndGenerateLocalLowHeartRateNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Aviso!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Batimnto cardíaco muito baixo!", arguments: nil)
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "myNotificationCategory"
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FallNotification", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request)
        
    }
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        print("Notificação")
    }
    
}
