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
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
   
    
    // MARK: - Status Bar styling
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // urobí biely status bar
        // treba však do Info.plist pridať "View controller-based status bar appearance" -> YES
        return .lightContent
    }
    
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
    
    
    @IBAction func saveProfileButtonAction(_ sender: UIBarButtonItem) {
        if (nicknameTextField.text!.characters.count > 8){
            nicknameInfo.text = "Nickname is too long"
            return
        }
        saveSelectedPhototoParse()
        transitToRegisteredUsersView()
    }
    
    private func saveSelectedPhototoParse(){
        let stateStorage = StateStorage()
        let registeredUserName = stateStorage.registeredUserName!
        
        let parseUserQuery = PFQuery(className: parseClassName).whereKey(userNameKey, equalTo: registeredUserName)
        parseUserQuery.findObjectsInBackground() { objects, error in
            if error != nil || objects!.count == 0 {
                return
            }
            
            if (objects!.count > 1){
                return
            }
        
            let object = objects?[0]
            let pickedImageData = UIImagePNGRepresentation(self.profilePictureView.image!)
            let parseImageFile = PFFile(name: "uploaded_image.png", data: pickedImageData!)!
            
            parseImageFile.saveInBackground(block: { (success, error) -> Void in
                if success {
                    object?["userImage"] = parseImageFile
                    
                    if (self.checkNickName()){
                        object?["nickName"] = self.nicknameTextField.text
                    }
                    object?.saveInBackground(block: { (success: Bool, error: Error?) -> Void in
                        if error == nil {
                            print("data uploaded")
                        } else {
                            print("nepodarilo sa")
                            print(error!)
                        }
                    })
                }
            })
        }
    }
    
    private func checkNickName() -> Bool {
        if let nickName = self.nicknameTextField.text {
            if nickName.characters.count > 8 {
                nicknameInfo.text = "Nickname is too long"
                return false
            }
            return true
        } else {
            nicknameInfo.text = "nickname is empty"
            return false
        }
    }
    
    private func transitToRegisteredUsersView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registeredUsersController = storyboard.instantiateViewController(withIdentifier: "NavigationController")
        present(registeredUsersController, animated: true, completion: nil)
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

