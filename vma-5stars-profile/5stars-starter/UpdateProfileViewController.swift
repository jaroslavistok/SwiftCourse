//
//  UpdateProfileViewController.swift
//  5stars-starter
//
//  Created by Jaroslav Istok on 07/01/2017.
//  Copyright © 2017 Touch4IT. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBAction func saveButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func selectFromGalleryAction(_ sender: UIBarButtonItem) {
    }
    @IBAction func shootPhotoAction(_ sender: UIBarButtonItem) {
    }

}
