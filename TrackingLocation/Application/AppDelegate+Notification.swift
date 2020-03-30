//
//  AppDelegate+Notification.swift
//  TrackingLocation
//
//  Created by ThinhLe on 3/30/20.
//  Copyright © 2020 ThinhLe. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized: break
            default:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted:Bool, error:Error?) in
                    if error != nil {
                        debugPrint((error?.localizedDescription)!)
                        return
                    }
                    if granted {
                        print("permission granted")
                    }
                }
                UNUserNotificationCenter.current().delegate = self
            }
        }
    }
    
    func scheduleLocalNotification(alert: String) {
        let content = UNMutableNotificationContent()
        let requestIdentifier = UUID.init().uuidString
        
        content.badge = 0
        content.title = "Location Update"
        content.body = alert
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            print("Notification Register Success")
        }
    }
}
