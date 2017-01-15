//
//  UpdateProfileViewController.swift
//  5stars-starter
//
//  Created by Jaroslav Istok on 07/01/2017.
//  Copyright © 2017 Touch4IT. All rights reserved.
//

import UIKit
import Parse

fileprivate let parseClassName = "ParseUser"
fileprivate let userNameKey = "userName"

class UpdateProfileViewController: UIViewController {
    
    public var userImage: UIImage?
    public var nickname: String? = ""
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    override func viewDidLoad() {
        print(nickname!)
        
        userImageView.image = userImage
        infoLabel.text = nickname
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

    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func selectFromGalleryAction(_ sender: UIBarButtonItem) {
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
   
    @IBAction func shootPhotoAction(_ sender: UIBarButtonItem) {
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
    
    @IBAction func saveProfileAction(_ sender: UIBarButtonItem) {
        saveSelectedPhototoParse()
        transitToRegisteredUsersView()
    }
    
    private func saveSelectedPhototoParse(){
        
        var storage = StateStorage()
        let selectedUserName = storage.selectedUser!
        print("selected user name: " + selectedUserName)
        
        let parseUserQuery = PFQuery(className: parseClassName).whereKey(userNameKey, equalTo: selectedUserName)
        parseUserQuery.findObjectsInBackground() { objects, error in
            if error != nil || objects!.count == 0 {
                return
            }
            
            if (objects!.count > 1){
                return
            }
            
            guard self.userImageView.image != nil else {
                return
            }
            
            let object = objects?[0]
            let pickedImageData = UIImagePNGRepresentation(self.userImageView.image!)
            let parseImageFile = PFFile(name: "uploaded_image.png", data: pickedImageData!)!
            
            parseImageFile.saveInBackground(block: { (success, error) -> Void in
                if success {
                    object?["userImage"] = parseImageFile
                    if (self.checkNickName()){
                        object?["nickName"] = self.nickNameTextField.text
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

    @IBOutlet weak var infoLabel: UILabel!
    
    private func checkNickName() -> Bool {
        if let nickName = self.nickNameTextField.text {
            if nickName.characters.count > 8 {
                infoLabel.text = "Nickname is too long"
                return false
            }
            return true
        } else {
            infoLabel.text = "nickname is empty"
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

extension UpdateProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        userImageView.image = chosenImage
        
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


