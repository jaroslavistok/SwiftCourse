//
//  RegistrationViewController.swift
//  5stars-starter
//
//  Created by Jaroslav Istok on 08/12/2016.
//  Copyright © 2016 Touch4IT. All rights reserved.
//

import UIKit
import Parse

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var informationLabel: UILabel!
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let username = userNameTextField.text
        view.endEditing(true)
        let parseUser = RegistrationManager(userName: username!)
        parseUser.signUp() { (_ success: Bool, _ error: Error?) -> Void in
            self.activityIndicator.startAnimating()
            if (success) {
                var stateStorage = StateStorage()
                stateStorage.isRegistered = true
                stateStorage.registeredUserName = username
                self.transitToProfilePictureUserViewController()
                self.stopActivityIndicator()
            } else {
                self.informationLabel.text = error?.localizedDescription
                self.stopActivityIndicator()
            }
        }
    }
    
    private func transitToProfilePictureUserViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profilePictureViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewConctroller
        
        present(profilePictureViewController, animated: true, completion: nil)
    }
    
    private func stopActivityIndicator(){
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.stopAnimating()
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            view.endEditing(true)
        }
        return true
    }
}
