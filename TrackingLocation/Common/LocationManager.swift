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
import Alamofire
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    var polygons = [MKPolygon]()
    
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
        var notification = Notification(name: Define.locationUpdate)
        notification.object = location
        NotificationCenter.default.post(notification)
        currentLocation = location
        if UIApplication.shared.applicationState == .active {
            guard let manager = NetworkReachabilityManager.default, manager.isReachable else {
                handleIfNoInternet(location: location)
                return
            }
            //send location to server
        } else {
            if let manager = NetworkReachabilityManager.default, !manager.isReachable {
                handleIfNoInternet(location: location)
            }
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
    
    private func handleIfNoInternet(location: CLLocation) {
        let text = "No internet: \(location.coordinate.latitude) - \(location.coordinate.longitude)"
        Logger.write(text: text, to: Logger.locationLog)
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        if self.isInSafeArea(coordinate: coordinate) {
            let text = "😍 You are safe 👌"
            if !UserInfoManager.shared.isSafe {
                let manager = LocalNotificationManager.shared
                manager.scheduleLocalNotification(alert: text)
            }
            UserInfoManager.shared.isSafe = true
        } else {
            let text = "⛔️ You are in a dangerous area ⛔️!!!"
            if UserInfoManager.shared.isSafe {
                let manager = LocalNotificationManager.shared
                manager.scheduleLocalNotification(alert: text)
            }
            UserInfoManager.shared.isSafe = false
        }
    }
    
    private func isInSafeArea(coordinate: CLLocationCoordinate2D) -> Bool {
        for polygon in polygons {
            let polygonRenderer = MKPolygonRenderer(polygon: polygon)
            let mapPoint: MKMapPoint = MKMapPoint(coordinate)
            let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)

            if polygonRenderer.path.contains(polygonViewPoint) {
                return false
            }
        }
        return true
    }
    
    private func getPolygons() {
        do {
            let data = haichau.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [[Double]] {
                var mapPoints = [MKMapPoint]()
                for point in jsonResult {
                    let coordinate = CLLocationCoordinate2D(latitude: point[1], longitude: point[0])
                    let mapPoint = MKMapPoint(coordinate)
                    mapPoints.append(mapPoint)
                }
                let polygon = MKPolygon(points: mapPoints, count: mapPoints.count)
                polygons.append(polygon)
            }
        } catch {
        }
        
        do {
            let data = lienchieu.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [[Double]] {
                var mapPoints = [MKMapPoint]()
                for point in jsonResult {
                    let coordinate = CLLocationCoordinate2D(latitude: point[1], longitude: point[0])
                    let mapPoint = MKMapPoint(coordinate)
                    mapPoints.append(mapPoint)
                }
                let polygon = MKPolygon(points: mapPoints, count: mapPoints.count)
                polygons.append(polygon)
            }
        } catch {
        }
    }
}
