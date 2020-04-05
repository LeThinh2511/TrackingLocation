//
//  AppDelegate.swift
//  TrackingLocation
//
//  Created by ThinhLe on 3/30/20.
//  Copyright © 2020 ThinhLe. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LocationManager.shared.configLocationManager()
        if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
            let text = "Launch by location event"
            Logger.write(text: text, to: Logger.locationLog)
        } else {
            registerNotifications()
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger.write(text: "applicationDidEnterBackground", to: Logger.locationLog)
        LocationManager.shared.startMoniteringCurrentRegion()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Logger.write(text: "applicationWillTerminate", to: Logger.locationLog)
        LocationManager.shared.startMoniteringCurrentRegion()
    }
}

