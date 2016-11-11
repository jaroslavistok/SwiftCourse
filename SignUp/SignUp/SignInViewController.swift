//
//  SignInViewController.swift
//  SignUp
//
//  Created by Jaroslav Istok on 03/11/2016.
//  Copyright © 2016 Touch4it. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var userLoginTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var reportLabel: UILabel! {
        didSet {
            reportLabel.text = ""
        }
    }

    private lazy var loginManager: LoginManager = {
        let manager = LoginManager()
        manager.onFailure = {errorMessage in
            self.reportLabel.text = errorMessage
            self.reportLabel.textColor = UIColor.red
        }
        
        manager.onSuccess = {
            self.reportLabel.text = "You are logged in!!!"
            self.reportLabel.textColor = UIColor.green
        }
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        clearReportMessage()
    }
    
    
    @IBAction func signInAction(_ sender: UIButton) {
        let email = userLoginTextField.text!
        let password = userPasswordTextField.text!
        loginManager.login(userEmail: email, userPassword: password)
    }
    
    @IBAction func dissmisKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func setBackgroundImage() {
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "bg.jpg")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    private func clearReportMessage(){
        if let label = reportLabel {
            label.text = ""
        }
    }
}
