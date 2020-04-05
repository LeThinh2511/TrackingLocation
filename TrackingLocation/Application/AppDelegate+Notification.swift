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
}
