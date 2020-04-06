//
//  LocalNotificationManager.swift
//  TrackingLocation
//
//  Created by ThinhLe on 4/5/20.
//  Copyright © 2020 ThinhLe. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    static let shared = LocalNotificationManager()
    
    private init() {}
    
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
