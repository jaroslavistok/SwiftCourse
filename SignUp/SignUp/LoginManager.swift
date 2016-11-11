//
//  LoginManager.swift
//  SignUp
//
//  Created by Jaroslav Istok on 10/11/2016.
//  Copyright © 2016 Touch4it. All rights reserved.
//

import Foundation

class LoginManager{
    
    private let keychainWrapper: KeychainSwift
    private let validator: Validator
    
    private var attemptsCounter: Int
    private var remainingSeconds: Int
    private weak var timer: Timer?
    
   
    init(){
        self.keychainWrapper = KeychainSwift()
        self.validator = Validator()
        
        self.attemptsCounter = 0
        self.remainingSeconds = 30
        self.timer = nil
    }
    
    func login(userEmail: String, userPassword: String) {
        let userPasswordFromKeychain = keychainWrapper.get(userEmail)
        
        guard timer == nil else {
            return
        }
        
        guard self.attemptsCounter <= 3 else {
            onFailure?("Too many attaempts, wait \(remainingSeconds) seconds")
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateRemainingSeconds), userInfo: nil, repeats: true)
            attemptsCounter = 0
            return
        }

        guard !userEmail.isEmpty else {
            onFailure?("No user email entered, try again")
            return
        }
        
        guard !userPassword.isEmpty else {
            onFailure?("No password entered, try again")
            return
        }

        guard validator.isValidEmail(emailAddress: userEmail) else {
            onFailure?("Wrong email format")
            return
        }
        
        guard userPasswordFromKeychain != nil else {
            onFailure?("User with given email doesn't exist")
            return
        }
        
        guard userPasswordFromKeychain == userPassword else {
            onFailure?("Wrong password")
            self.attemptsCounter += 1
            return
        }
        
        onSuccess?()
    }
    
    @objc func updateRemainingSeconds(timer: Timer){
        remainingSeconds -= 1
        if (remainingSeconds <= 1){
            onFailure?("You can try again now")
            timer.invalidate()
            remainingSeconds = 30
            attemptsCounter = 0
            return
        }
        print("Decrement was fired")
        onFailure?("Too many attaempts, wait \(remainingSeconds) seconds")
    }
    
    typealias Action = () -> Void
    typealias Error = (String) -> Void
    
    var onFailure: Error?
    var onSuccess: Action?
}
