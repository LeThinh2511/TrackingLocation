//
//  ViewController.swift
//  TrackingLocation
//
//  Created by ThinhLe on 3/30/20.
//  Copyright © 2020 ThinhLe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let currentLocation = appDelegate.currentLocation else {
            return
        }
        
        locationLabel.text = "\(currentLocation.coordinate.latitude) -  \(currentLocation.coordinate.longitude)"
    }

    @IBAction func didTapStartTracking(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let currentLocation = appDelegate.currentLocation else {
            return
        }
        
        locationLabel.text = "\(currentLocation.coordinate.latitude) -  \(currentLocation.coordinate.longitude)"
        appDelegate.trackUserLocation()
    }
}

