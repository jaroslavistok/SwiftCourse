//
//  StateStorage.swift
//  5stars-starter
//
//  Created by Jaroslav Istok on 08/12/2016.
//  Copyright © 2016 Touch4IT. All rights reserved.
//

import Foundation


struct StateStorage {
    private let isRegisteredKey = "isRegistered"
    var isRegistered: Bool {
        get {
            let defaults = UserDefaults.standard
            return defaults.bool(forKey: isRegisteredKey)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: isRegisteredKey)
            defaults.synchronize()
        }
    }
    
    private let registeredUserNameKey = "registeredUser"
    var registeredUserName: String? {
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: registeredUserNameKey)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: registeredUserNameKey)
            defaults.synchronize()
        }
    }
}
