//
//  RegisteredUsersViewController.swift
//  5stars-starter
//
//  Created by Jaroslav Istok on 09/12/2016.
//  Copyright © 2016 Touch4IT. All rights reserved.
//

import UIKit
import Parse

class RegisteredUsersViewController: UITableViewController {
    var isPresented = false
    
    @IBAction func refresh(_ sender: Any) {
        self.users.removeAll()
        self.tableView.reloadData()
        populateTable()
    }
    
    @IBAction func logout(_ sender: Any) {
        var store = StateStorage()
        store.isRegistered = false
        store.registeredUserName = ""
        
        if isPresented {
            dismiss(animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController")
            present(signInVC, animated: true, completion: nil)
        }
    }
    
    var users = [UserItem]()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = CGFloat(80)
        createActivityIndicator()
        populateTable()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell \(indexPath.row)!")
        let selectedCell = tableView.cellForRow(at: indexPath)! as! RegisteredUserViewCell
        
        let updateController = storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
        print("Presenting")
        updateController.nickname = selectedCell.userNameLabel.text!
        updateController.userImage = selectedCell.userImageView.image!
        navigationController?.pushViewController(updateController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! RegisteredUserViewCell
        let item = users[indexPath.row]
        if (item.nickname == ""){
            print(item.nickname)
            cell.userNameLabel.text = item.name
        } else {
            cell.userNameLabel.text = item.nickname
        }
        cell.userImageView.image = item.image
        return cell
    }
    
    private func createActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    private func populateTable(){

        let query = PFQuery(className: "ParseUser").selectKeys(["userName", "userImage", "nickName"])
        self.activityIndicator.startAnimating()
        
        query.findObjectsInBackground { objects, error in
            guard let objects = objects else { return }
            
            let stateStorage = StateStorage()
            
            for (_, object) in objects.enumerated() {
                
                if object["userImage"] == nil  {
                    let user = UserItem(image: UIImage(named: "placeholder.png")!, name: object["userName"] as! String, nickname: object["nickName"] as! String)
                    let storage = StateStorage()
                    if (user.name != storage.registeredUserName!){
                        self.addUserAndRefresh(user: user)
                    }
                    continue
                }
                
                let userImageData = object["userImage"] as! PFFile
                let userName = object["userName"] as! String
                
                var userNickname = ""
                if (object["nickName"] != nil){
                    userNickname = object["nickName"] as! String
                }
                
                userImageData.getDataInBackground { (imageData: Data?, error: Error?) -> Void in
                    guard error == nil else { return }
                    if (stateStorage.registeredUserName! != userName){
                        let image =  UIImage(data:imageData!)!
                        let userItem = UserItem(image: image, name: userName, nickname: userNickname)
                        self.addUserAndRefresh(user: userItem)
                    }
                }
            }
        }
    }
    
    private func addUserAndRefresh(user: UserItem) -> Void {
        self.users.append(user)
        self.tableView.reloadData()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.stopAnimating()
    }
    
}
