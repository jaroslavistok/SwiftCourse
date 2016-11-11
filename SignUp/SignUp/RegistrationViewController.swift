//
//  RegistrationViewController.swift
//  SignUp
//
//  Created by Jaroslav Istok on 03/11/2016.
//  Copyright © 2016 Touch4it. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel! {
        didSet {
            informationLabel.text = ""
        }
    }
    @IBOutlet weak var suggestionLabel: UILabel!
    
    private let validator = Validator()
    
    private lazy var registrationManager: RegistrationManager = {
        let manager = RegistrationManager()
        manager.onFailure = { errorMessage in
            self.informationLabel.text = errorMessage
            self.informationLabel.textColor = UIColor.red
        }
        
        manager.onSuccess = {
            self.informationLabel.text = "Registration was successful!"
            self.informationLabel.textColor = UIColor.green
        }
        
        return manager
    }()
    
    override func viewDidLoad() {
        setBackgroundImage()
        super.viewDidLoad()
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {}

    @IBAction func hideKeyboardAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        clearReportMessage()
        clearPasswordStrengthMessage()
        clearPasswordHint()
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        registrationManager.register(userEmail: email, userPassword: password)
    }
    
    @IBAction func typingPasswordAction(_ sender: Any) {
        let currentPassword = passwordTextField.text!
        let passwordStrength = validator.checkPasswordStrength(password: currentPassword)
        suggestionLabel.text = "Password should include at least one uppercase letter, digit nad special character"
        suggestionLabel.textColor = UIColor.white

        switch passwordStrength {
            case .TOO_SHORT:
                informationLabel.text = "PASSWORD IS TOO SHORT"
                informationLabel.textColor = UIColor.red
            case .WEAK:
                informationLabel.text = "WEAK"
                informationLabel.textColor = UIColor.red
            case .MEDIUM:
                informationLabel.text = "MEDIUM"
                informationLabel.textColor = UIColor.orange
            case .STRONG:
                informationLabel.text = "STRONG"
                informationLabel.textColor = UIColor.green
            case .VERY_STRONG:
                informationLabel.text = "VERY STRONG"
                informationLabel.textColor = UIColor.green
                suggestionLabel.text = ""
            case .UNKNOWN:
                informationLabel.text = "UNKNOWN VALUE"
                informationLabel.textColor = UIColor.black
        }
    }
    
       
    private func clearReportMessage(){
        if let label = reportLabel {
            label.text = ""
        }
    }
    
    private func clearPasswordStrengthMessage(){
        if let label = informationLabel {
            label.text = ""
        }
    }
    
    private func clearPasswordHint(){
        if let label = suggestionLabel{
            label.text = ""
        }
    }
    
    private func setBackgroundImage() {
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "bg.jpg")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
}
