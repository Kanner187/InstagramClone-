//
//  User.swift
//  instagramClone
//
//  Created by Levit Kanner on 13/09/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import Foundation
import Firebase

class User {
    //Mark: - Properties
    var username : String!
    var fullname : String!
    var profileImageURL : String!
    var uid : String!
    var isFollowed : Bool = false

    
    //Mark: - Initialization 
    init (uid : String , dictionary : [String : Any]) {
        
        self.uid = uid
        
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        
        if let fullname = dictionary["fullname"] as? String{
            self.fullname = fullname
        }
        
        if let ProfileImageUrl = dictionary["profileImageURL"] as? String{
            self.profileImageURL = ProfileImageUrl
        }
    }
    
    //Mark: - Methods
    
    func follow (){
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        guard let uid = uid else {return}
        
        self.isFollowed = true
        
        //Adds current users to the following of the selected user
        user_following.child(currentUser).updateChildValues([uid: 1])
        
        //Adds the user followed to the following of the current user
        user_followers.child(uid).updateChildValues([currentUser : 1])
    }
    
    func unfollow(){
        guard let currentUser = currentUser?.uid else {return}
        guard let uid = uid else { return}
        
        self.isFollowed = false
        user_following.child(currentUser).child(uid).removeValue()
        user_followers.child(uid).child(currentUser).removeValue()
    }
    
    
    func checkIfUserIsFollowed(completion : @escaping(Bool) -> ()){
        guard let currentUid = currentUser?.uid else { return }
        
        user_following.child(currentUid).observeSingleEvent(of: .value) { (DataSnapshot) in
            if DataSnapshot.hasChild(self.uid) {
                self.isFollowed = true
               completion(true)
            }else {
                self.isFollowed = false
                completion(false)
            }
        }
    }
    
    
}
