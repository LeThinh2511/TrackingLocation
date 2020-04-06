//
//  LocationManager.swift
//  TrackingLocation
//
//  Created by ThinhLe on 4/5/20.
//  Copyright © 2020 ThinhLe. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    private override init() {}
    
    func configLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        requestLocationAlwaysAuthorization()
    }
    
    func requestLocationAlwaysAuthorization() {
        guard CLLocationManager.authorizationStatus() != .authorizedAlways else {
            return
        }
        locationManager.requestAlwaysAuthorization()
    }
    
    func startMoniteringCurrentRegion() {
        guard let location = currentLocation else {
            Logger.write(text: "Problem with location in creating region", to: Logger.locationLog)
            return
        }

        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let id = "\(location.coordinate.latitude) - \(location.coordinate.longitude)"
            let region = CLCircularRegion(center: location.coordinate, radius: 50.0, identifier: id)
            region.notifyOnExit = true
            locationManager.stopUpdatingLocation()
            locationManager.startMonitoring(for: region)
            Logger.write(text: "Start Monitoring", to: Logger.locationLog)
        } else {
            Logger.write(text: "System can not track user's location", to: Logger.locationLog)
        }
    }
    
    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestLocationAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        currentLocation = location
        var notification = Notification(name: Define.locationUpdate)
        notification.object = location
        NotificationCenter.default.post(notification)
        if UIApplication.shared.applicationState == .active {
            //send location to server
            let text = "Active: \(location.coordinate.latitude) - \(location.coordinate.longitude)"
            Logger.write(text: text, to: Logger.locationLog)
        } else {
            //send location to server
            startMoniteringCurrentRegion()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        let text = "Monitor region: \(region.identifier)"
        Logger.write(text: text, to: Logger.locationLog)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let text = "Exit region: \(region.identifier)"
        Logger.write(text: text, to: Logger.locationLog)
        locationManager.stopMonitoring(for: region)
        locationManager.startUpdatingLocation()
    }
}
