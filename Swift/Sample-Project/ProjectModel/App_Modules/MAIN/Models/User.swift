//
//  User.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 25/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit

struct UserModel: Codable {
    
    let id: Int
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email = "user_email"
        case password = "user_password"
    }
}
