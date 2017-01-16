//
//  RatingViewController.swift
//  5stars-starter
//
//  Created by Jaroslav Istok on 14/01/2017.
//  Copyright © 2017 Touch4IT. All rights reserved.
//

import UIKit
import Parse

class RatingViewController: UIViewController {

    public var userImage: UIImage?
    public var nickname: String?
    public var userName: String?
    
    public var assessmentUserStatus: Int?
    public var userToRateStatus: Int?
    public var userToRateRating: Float?
    
    public var starsSelected: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var stateStorage = StateStorage()
        let registeredUser = stateStorage.registeredUserName
        let userToRate = nickname
        let welcomeString = "Welcome \(registeredUser!) do you want to give rating to \(userToRate!) ?"
        welcomeText.text = welcomeString
        userImageView.image = userImage!
        
        ratingLabel.text = ratingLabel.text! + String(describing: userToRateRating!)
        saveButton.isEnabled = false
        
        let storage = StateStorage()
        let assesmentUserName = storage.registeredUserName
        let query = PFQuery(className: "ParseUser").selectKeys(["status"]).whereKey("userName", equalTo: assesmentUserName!)
        
        print(assesmentUserName!)
        
        query.findObjectsInBackground { [unowned self] objects, error in
            guard let objects = objects else { return }
            print("In closure \(error)")
            guard error == nil else {
                return
            }
            print("Obejcts count \(objects.count)")
            if (objects.count == 1){
                let object = objects[0]
                var status = 5
                if (object["status"] != nil){
                    status = object["status"] as! Int
                }
                self.assessmentUserStatus = status
                print("assesment status \(self.assessmentUserStatus)")
            }
        }
    }
    @IBOutlet weak var saveButton: UIBarButtonItem!
    

    
    public func saveNewStatusAndRating(rating: Float, status: Float){
        let query = PFQuery(className: "ParseUser").selectKeys(["status"]).whereKey("userName", equalTo: userName!)

        
        query.findObjectsInBackground { objects, error in
            print("")
            guard let objects = objects else { return }
            print("In closure \(error)")
            guard error == nil else {
                return
            }
            print("Obejcts count \(objects.count)")
            if (objects.count == 1){
                let object = objects[0]
                object["rating"] = rating
                object["status"] = status
                
                print("Rating: \(rating)")
                print("Status: \(status)")
                object.saveInBackground(block: { (success: Bool, error: Error?) -> Void in
                    if error == nil {
                        print("Status and rating updated")
                    } else {
                        print("nepodarilo sa updatovat status a rating")
                        print(error!)
                    }
                })
            }
        }
        
        _ = navigationController?.popToRootViewController(animated: true)
        let rController = storyboard?.instantiateViewController(withIdentifier: "RegisteredUsersController") as! RegisteredUsersViewController
        rController.shouldRefresh = true
        
    }
    @IBAction func saveButtonAction(_ sender: Any) {
        let weight :Float = Float(assessmentUserStatus!) / Float(5.0)
        print("Weight: \(weight)")
        
        
        var rating : Float = 0.0
        if (starsSelected == 5){
            rating = +1 * 5 * 0.01 * weight
        } else {
            rating = Float(-1) * Float((5 - starsSelected!)) * 0.01 * weight
        }
        
        let newStatus = min(Float(userToRateStatus!) + userToRateRating!, 5)
        
      
        print("saving")
        saveNewStatusAndRating(rating: rating, status: newStatus)
    }
    
    @IBOutlet weak var userImageView: UIImageView!
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
        starsSelected = 1
        saveButton.isEnabled = true
    }
    
    @IBAction func twoStarAction(_ star: UIButton) {
        resetStates()
        star.isSelected = !star.isSelected
        oneStar.isSelected = !oneStar.isSelected
        starsSelected = 2
        saveButton.isEnabled = true
    }
    
    @IBAction func threeStarAction(_ star: UIButton){
        resetStates()
        star.isSelected = !star.isSelected
        oneStar.isSelected = !oneStar.isSelected
        twoStar.isSelected = !twoStar.isSelected
        starsSelected = 3
        saveButton.isEnabled = true
    }
    
    @IBAction func fourStarAction(_ star: UIButton) {
        resetStates()
        star.isSelected = !star.isSelected
        oneStar.isSelected = !oneStar.isSelected
        twoStar.isSelected = !twoStar.isSelected
        threeStar.isSelected = !threeStar.isSelected
        starsSelected = 4
        saveButton.isEnabled = true
    }
    
    @IBAction func fiveStarAction(_ star: UIButton) {
        resetStates()
        star.isSelected = !star.isSelected
        oneStar.isSelected = !oneStar.isSelected
        twoStar.isSelected = !twoStar.isSelected
        threeStar.isSelected = !threeStar.isSelected
        fourStar.isSelected = !fourStar.isSelected
        starsSelected = 5
        saveButton.isEnabled = true
    }
}
