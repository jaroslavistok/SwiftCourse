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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! RegisteredUserViewCell
        let item = users[indexPath.row]
        cell.userNameLabel.text = item.name
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

        let query = PFQuery(className: "ParseUser").selectKeys(["userName", "userImage"])
        self.activityIndicator.startAnimating()
        
        query.findObjectsInBackground { objects, error in
            guard let objects = objects else { return }
            
            let stateStorage = StateStorage()
            
            for (_, object) in objects.enumerated() {
                
                if object["userImage"] == nil  {
                    let user = UserItem(image: UIImage(named: "placeholder.png")!, name: object["userName"] as! String)
                    let storage = StateStorage()
                    if (user.name != storage.registeredUserName!){
                        self.addUserAndRefresh(user: user)
                    }
                    continue
                }
                
                let userImageData = object["userImage"] as! PFFile
                let userName = object["userName"] as! String
                
                userImageData.getDataInBackground { (imageData: Data?, error: Error?) -> Void in
                    guard error == nil else { return }
                    if (stateStorage.registeredUserName! != userName){
                        let image =  UIImage(data:imageData!)!
                        let userItem = UserItem(image: image, name: userName)
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
