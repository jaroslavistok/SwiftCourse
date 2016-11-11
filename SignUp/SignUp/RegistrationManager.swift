//
//  RegistrationManager.swift
//  SignUp
//
//  Created by Jaroslav Istok on 10/11/2016.
//  Copyright © 2016 Touch4it. All rights reserved.
//

import Foundation


class RegistrationManager {
    private let keychainWrapper: KeychainSwift
    private let validator: Validator
    
    init() {
        self.keychainWrapper = KeychainSwift()
        self.validator = Validator()
    }
    
    func register(userEmail: String, userPassword: String){
        guard !userEmail.isEmpty else {
            onFailure?("No email entered")
            return
        }
        
        guard !userPassword.isEmpty else {
            onFailure?("No password entered")
            return
        }
        
        guard validator.isValidEmail(emailAddress: userEmail) else {
            onFailure?("Email address has wrong format")
            return
        }
        
        guard userPassword.characters.count > 5 else {
            onFailure?("Password is too short")
            return
        }
        
        guard !validator.userAlreadyExist(email: userEmail) else {
            onFailure?("Email already exist")
            return
        }
        
        keychainWrapper.set(userPassword, forKey: userEmail)
        onSuccess?()
    }
    
    typealias Error = (String) -> Void
    typealias Action = () -> Void
    
    var onFailure: Error?
    var onSuccess: Action?
}
