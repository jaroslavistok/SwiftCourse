//
//  RegisteredUserViewCell.swift
//  5stars-starter
//
//  Created by Jaroslav Istok on 09/12/2016.
//  Copyright © 2016 Touch4IT. All rights reserved.
//

import UIKit

class RegisteredUserViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userRating: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    
    public var userName: String?
}
