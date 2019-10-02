//
//  userProfileVC.swift
//  instagramClone
//
//  Created by Levit Kanner on 10/09/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "profileHeader"


//Inherit from the collectionviewdelegateflowlayout super class to set the size of the registered header cell
class userProfileVC: UICollectionViewController , UICollectionViewDelegateFlowLayout , userProfileHeaderDelegate{
 
    //MARK: - PROPERTIES
    var user : User?
    
    
    //MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .white
        
        //fetch user data
        if self.user == nil {
            fetchCurrentUserData()
        }
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.register(profileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }

    

    //MARK: - DELEGATE FUNCTIONS
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    
    
    
    //MARK: -HEADER CONFIGURATION
    
    //Implement the size function. Just start typing "reference"
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
    
    
    //Configure supplementary header cell
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! profileHeader
        header.delegate = self       //Set header delegate

        //Set user value of the header
        header.user = self.user
        navigationItem.title = user?.username

        return header
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) 
        return cell
    }
    
    

    
    //MARK: - USERPROFILEHEADER PROTOCOL
    
    func configureEditFollowButton(for header: profileHeader) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let user = header.user else {return}
        
        if uid == user.uid {
            //configure editFollowButton as edit button
            header.editProfileFollowButton.setTitle("Edit Profile", for: .normal)
        }else {
            user.checkIfUserIsFollowed { (followed) in
                if followed{
                    header.editProfileFollowButton.setTitle("Following", for: .normal)
                }else{
                    header.editProfileFollowButton.setTitle("Follow", for: .normal)
                }
                
                //configure edit button as follow button
                header.editProfileFollowButton.backgroundColor = UIColor(displayP3Red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
                header.editProfileFollowButton.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    
    
    func setUserStats(for header: profileHeader) {
        var numberOfFollowers : Int!
        var numberOfFollowing : Int!
        
        guard let uid = header.user?.uid else { return }
        // Get number of followers by casting the snapshot as a dictionary
        user_following.child(uid).observe(.value) { (DataSnapshot) in
            if let following = DataSnapshot.value as? Dictionary<String , Any>{
                numberOfFollowing = following.count
            }else{
                numberOfFollowing = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing!)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            let postString = NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) ,NSAttributedString.Key.foregroundColor : UIColor.black ])
            attributedText.append(postString)
            header.followingLabel.attributedText = attributedText
        }
        
        //Get number of following
        user_followers.child(uid).observe(.value) { (DataSnapshot) in
            if let followers = DataSnapshot.value as? Dictionary<String, Any> {
                numberOfFollowers = followers.count
            }else {
                numberOfFollowers = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowers!)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            let postString = NSAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) ,NSAttributedString.Key.foregroundColor : UIColor.black ])
            attributedText.append(postString)
            header.followersLabel.attributedText = attributedText
        }
        
        //Get number of Posts
    }
    
    
    
    //MARK: - HANDLERS
    func handleEditButtonTapped(for header: profileHeader) {
        if header.editProfileFollowButton.titleLabel?.text == "Edit Profile"{
            print("Handle edit user Profile")
            
        }else {
            if header.editProfileFollowButton.titleLabel?.text == "Follow"{
               header.user?.follow()
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                
            }else{
                header.user?.unfollow()
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                
            }
        }
    }
    
    func handleFollowersTapped(for header: profileHeader) {
        let followersVC = followVC()
        followersVC.viewFollowers = true
        followersVC.uid = user?.uid
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    func handleFollowingTapped(for header: profileHeader) {
        let followingVC = followVC()
        followingVC.viewFollowing = true
        followingVC.uid = user?.uid
        navigationController?.pushViewController(followingVC, animated: true)
    }
    
    

    
    //MARK: - API
    func fetchCurrentUserData(){
        //To get data on the current user, first get the user's uid
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        let userData = usersReference.child(currentUserUid)
        
        userData.observeSingleEvent(of: .value) { (DataSnapshot) in
            guard let dictionary = DataSnapshot.value as? Dictionary <String , Any> else {return}
            let uid = DataSnapshot.key
            let retrievedUser =  User(uid: uid , dictionary: dictionary)
            self.user = retrievedUser
            
            // Set the navigation item title to the username of the current user
            self.navigationItem.title = retrievedUser.username
            self.collectionView.reloadData()
        }
    }
}

