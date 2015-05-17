//
//  User.swift
//  BoomDate
//
//  Created by Robin Somlette on 16-05-2015.
//  Copyright (c) 2015 Robin Somlette. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let id: String
 //   let pictureURL: String
    let name: String
    private let pfUser: PFUser
    
    func getPhoto(callback:(UIImage) -> ()) {
        let imageFile = pfUser.objectForKey("picture") as! PFFile
        imageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            if let data = data {
                callback(UIImage(data: data)!)
            }
        }
    }
}


private func pfUserToUser(user: PFUser) -> User {
    return User(id: user.objectId!, name: user.objectForKey("firstName") as! String, pfUser: user)
}

func currentUser() -> User? {
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    return nil
}

func fetchUnViewedUsers(callback: ([User]) -> ()) {
    var query = PFUser.query()
    query?.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
    query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
        if let pfUsers = objects as? [PFUser] {
            let users = map(pfUsers, {pfUserToUser($0)})
            callback(users)
        }
    })
}