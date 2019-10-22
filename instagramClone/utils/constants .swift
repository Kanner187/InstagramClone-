//
//  constants .swift
//  instagramClone
//
//  Created by Levit Kanner on 21/09/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import Foundation
import Firebase
/*
 CREDENTIALS TO LOGIN WITH
 Email : danieltetteh@gmail.com
 Password : llllllll
 */


//Root references
let DatabaseReference = Database.database().reference()
let StorageReference = Storage.storage().reference()


// Authentication
let Authenticated = Auth.auth()
let currentUser = Authenticated.currentUser


//Database references
let usersReference = DatabaseReference.child("users")
let user_following = DatabaseReference.child("user_following")
let user_followers = DatabaseReference.child("user_followers")


//Storage References
let profile_image_ref = StorageReference.child("profileImages")

//Post reference
let postReference = DatabaseReference.child("posts")
