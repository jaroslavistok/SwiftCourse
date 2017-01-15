//
//  RatingViewController.swift
//  5stars-starter
//
//  Created by Jaroslav Istok on 14/01/2017.
//  Copyright © 2017 Touch4IT. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    public var userImage: UIImage?
    public var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var stateStorage = StateStorage()
        let registeredUser = stateStorage.registeredUserName
        let userToRate = nickname
        let welcomeString = "Welcome \(registeredUser!) do you want to give rating to \(userToRate!) ?"
        welcomeText.text = welcomeString
        userImageView.image = userImage!
    
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBAction func saveAction(_ sender: Any) {
    }
    
    @IBOutlet weak var welcomeText: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    // buttons
    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStar: UIButton!
    @IBOutlet weak var threeStar: UIButton!
    @IBOutlet weak var fourStar: UIButton!
    @IBOutlet weak var fiveStar: UIButton!
    
    func resetStates(){
        oneStar.isSelected = false
        twoStar.isSelected = false
        threeStar.isSelected = false
        fourStar.isSelected = false
        fiveStar.isSelected = false
    }
    
    @IBAction func oneStarAction(_ star: UIButton) {
        resetStates()
        star.isSelected = !star.isSelected
    }
    
    @IBAction func twoStarAction(_ star: UIButton) {
        resetStates()
        star.isSelected = !star.isSelected
        oneStar.isSelected = !oneStar.isSelected
    }
    
    @IBAction func threeStarAction(_ star: UIButton){
        resetStates()
        star.isSelected = !star.isSelected
        oneStar.isSelected = !oneStar.isSelected
        twoStar.isSelected = !twoStar.isSelected
    }
    
    @IBAction func fourStarAction(_ star: UIButton) {
        resetStates()
        star.isSelected = !star.isSelected
        oneStar.isSelected = !oneStar.isSelected
        twoStar.isSelected = !twoStar.isSelected
        threeStar.isSelected = !threeStar.isSelected
    }
    
    @IBAction func fiveStarAction(_ star: UIButton) {
        resetStates()
        star.isSelected = !star.isSelected
        oneStar.isSelected = !oneStar.isSelected
        twoStar.isSelected = !twoStar.isSelected
        threeStar.isSelected = !threeStar.isSelected
        fourStar.isSelected = !fourStar.isSelected
    }
    
    
    
}
