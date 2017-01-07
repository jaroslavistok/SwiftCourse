//
//  ProfileViewConctroller.swift
//  5stars-starter
//
//  Created by Jaroslav Istok on 07/01/2017.
//  Copyright © 2017 Touch4IT. All rights reserved.
//

import UIKit
import Parse


fileprivate let parseClassName = "ParseUser"
fileprivate let userNameKey = "userName"

class ProfileViewConctroller: UIViewController {
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var nicknameInfo: UILabel!
    
    
    // MARK: - Status Bar styling
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // urobí biely status bar
        // treba však do Info.plist pridať "View controller-based status bar appearance" -> YES
        return .lightContent
    }
    
    // MARK: - Private vars
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()

    @IBAction func chooseImageFromGallery(_ sender: UIBarButtonItem) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        /*
         prezentovanie na celú obrazovku nie je vhodné pre iPad
         presentViewController(imagePicker, animated: true, completion: nil)
         */
        // lepší spôsob je prezentovať picker v popover:
        imagePicker.modalPresentationStyle = .popover
        imagePicker.popoverPresentationController?.barButtonItem = sender
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shootImage(_ sender: UIBarButtonItem) {
        // lepšie je overiť či hw má kameru
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            
            present(imagePicker, animated: true, completion: nil)
            
        } else {
            showAlert()
        }
        

    }
    
    
    @IBAction func saveProfileAction(_ sender: Any) {
        saveSelectedPhototoParse()
        transitToRegisteredUsersView()
        
    }
    
    private func saveSelectedPhototoParse(){
       
        let stateStorage = StateStorage()
        
        let registeredUserName = stateStorage.registeredUserName
        
        
        let parseUserQuery = PFQuery(className: parseClassName).whereKey(userNameKey, equalTo: registeredUserName!)
        parseUserQuery.findObjectsInBackground() { objects, error in
        
            if error != nil || objects!.count == 0 {
                return
            }
            
            if (objects!.count > 1){
                return
            }
            
            let object = objects?[0]
            
            object?["userImage"] = self.profilePictureView.image
            object?["nickName"] = self.nicknameTextField.text
            object?.saveInBackground()
        }
    }
    
    private func transitToRegisteredUsersView(){
        
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Chyba", message: "Vaše zariadenie nemá kameru.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
  
}


//MARK: UIImagePickerControllerDelegate

extension ProfileViewConctroller: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePictureView.image = chosenImage
        
        // uloženie image do photos
        if (picker.sourceType == .camera) {
            UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
        }
        
        // príklad zmeny rozmerov napr. pred odoslaním
        _ = chosenImage.resizedImage(withTargetSize: CGSize(width: 400, height: 400))
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

