//
//  UserInfoManager.swift
//  TrackingLocation
//
//  Created by ThinhLe on 4/6/20.
//  Copyright © 2020 ThinhLe. All rights reserved.
//

import Foundation

class UserInfoManager {
    static let shared = UserInfoManager()
    
    private init() {}
    
    var isSafe: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Key.isSafe)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isSafe)
        }
    }
    
    private struct Key {
        static let isSafe = "IS_SAFE"
    }
}
