//
//  Validator.swift
//  SignUp
//
//  Created by Jaroslav Istok on 10/11/2016.
//  Copyright © 2016 Touch4it. All rights reserved.
//

import Foundation


class Validator {
    private let keychainWrapper: KeychainSwift
    
    init() {
        keychainWrapper = KeychainSwift()
    }
    
    public func userAlreadyExist(email: String) -> Bool {
        guard keychainWrapper.get(email) == nil else {
            return true
        }
        return false
     }

    public func isValidEmail(emailAddress: String) -> Bool {
        let validator = NSPredicate(format: "SELF MATCHES %@", Matchers.emailValidation)
        return validator.evaluate(with: emailAddress)
    }

    public func checkPasswordStrength(password: String) -> PasswordStrengthLevels {
        var passwordRating = 0
        
        if password.count < 5 {
            return PasswordStrengthLevels.TOO_SHORT
        }
        
        if checkIf(text: password, matcher: Matchers.hasCapitalLetter) {
            passwordRating += 1
        }
        
        if checkIf(text: password, matcher: Matchers.hasDigit) {
            passwordRating += 1
        }
        
        if checkIf(text: password, matcher: Matchers.hasSpecialCharacter) {
            passwordRating += 1
        }
        
        return getPasswordStrength(passwordRating: passwordRating)
    }
    
    private func getPasswordStrength(passwordRating: Int) -> PasswordStrengthLevels {
        switch passwordRating {
            case 0:
                return PasswordStrengthLevels.WEAK
            case 1:
                return PasswordStrengthLevels.MEDIUM
            case 2:
                return PasswordStrengthLevels.STRONG
            case 3:
                return PasswordStrengthLevels.VERY_STRONG
            default:
                return PasswordStrengthLevels.UNKNOWN
        }
    }
    
    private func checkIf(text: String, matcher: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", matcher)
        return predicate.evaluate(with: text)
    }
    
    struct Matchers {
        static let hasCapitalLetter = ".*[A-Z]+.*"
        static let hasDigit = ".*[0-9]+.*"
        static let hasSpecialCharacter = ".*[!&^%$#@()/?.,]+.*"
        static let emailValidation = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    }
    
}
