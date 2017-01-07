/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

import UIKit

import Parse

// If you want to use any of the UI components, uncomment this line

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // ****************************************************************************
        // Initialize Parse SDK
        // ****************************************************************************
        // 5stars App at back4app.com
        let configuration = ParseClientConfiguration {
            $0.applicationId = "jGYBGSp6LXln8zfLL014qr27Qj2BcuhyawclOEsb"
            $0.clientKey = "qcugp8AbONeqgbBDH8sl9FOfwowi04AcYTXAecfA"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        
        let defaultACL = PFACL()
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.getPublicReadAccess = true
        defaultACL.getPublicWriteAccess = true
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        // Auto signingin after relaunch of application
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if StateStorage().isRegistered {
            let registeredUsersViewController = storyboard.instantiateViewController(withIdentifier: "NavigationController")
            window!.rootViewController = registeredUsersViewController
        } else {
            let registrationViewController = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController")
            window!.rootViewController = registrationViewController
        }
        
        window!.makeKeyAndVisible()
        return true

    }
    
}
