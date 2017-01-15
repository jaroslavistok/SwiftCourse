//
//  User.swift
//  5stars
//
//  Created by Lubos Ilcik on 15/11/2016.
//  Copyright © 2016 Touch4IT. All rights reserved.
//

import Foundation
import Parse

fileprivate let className = "ParseUser"
fileprivate let userNameKey = "userName"

fileprivate let domain = "com.touch4it.vma"
let userNameEmptyErrorCode = -5001
let userNameAlreadyTakenErrorCode = -5002

struct RegistrationManager {
    let userName: String
 
    func signUp(_ withBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        guard !userName.isEmpty else {
            let err = NSError(domain: domain, code: userNameEmptyErrorCode, userInfo: [NSLocalizedDescriptionKey: "User name is empty."])
            withBlock(false, err)
            return
        }
        
        let parseUserQuery = PFQuery(className: className).whereKey(userNameKey, equalTo: userName)
        parseUserQuery.countObjectsInBackground { count, error in
            
            if error != nil {
                withBlock(false, error)
                return
            }
            
            if count == 0 {
                self.saveUserName(withBlock)
            } else {
                let err = NSError(domain: domain, code: userNameAlreadyTakenErrorCode, userInfo: [NSLocalizedDescriptionKey: "User name already taken."])
                withBlock(false, err)
            }
        }
    }
    
    private func saveUserName(_ block: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let parseUser = PFObject(className: className)
        parseUser[userNameKey] = userName
        parseUser.saveInBackground (block: block)
    }
    
}
