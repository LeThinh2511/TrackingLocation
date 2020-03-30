//
//  AppDelegate+Location.swift
//  TrackingLocation
//
//  Created by ThinhLe on 3/30/20.
//  Copyright © 2020 ThinhLe. All rights reserved.
//

import Foundation
import CoreLocation

extension AppDelegate: CLLocationManagerDelegate {
    
    func configLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
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
    
    func trackUserLocation() {
        guard let location = currentLocation else {
            Logger.write(text: "Problem with location in creating region", to: Logger.locationLog)
            return
        }
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let region = CLCircularRegion(center: location.coordinate, radius: 5.0, identifier: "currentRegion")
            region.notifyOnExit = true
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
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        let text = "Monitor region: \(region.identifier)"
        Logger.write(text: text, to: Logger.locationLog)
        scheduleLocalNotification(alert: text)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let text = "Exit region: \(region.identifier)"
        Logger.write(text: text, to: Logger.locationLog)
        scheduleLocalNotification(alert: text)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let text = "Enter region: \(region.identifier)"
        Logger.write(text: text, to: Logger.locationLog)
        scheduleLocalNotification(alert: text)
    }
}
