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


//inherit from the collectionviewdelegateflowlayout super class to set the size of the registered cell
class userProfileVC: UICollectionViewController , UICollectionViewDelegateFlowLayout , userProfileHeaderDelegate{

    var user : User?
    
    var userPassedFromSearch : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .white
        
        //fetch user data
        if userPassedFromSearch == nil {
            fetchCurrentUserData()
        }
        
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //Register the collection view cell
        self.collectionView!.register(profileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    
    
    
    //implement the size function. Just start typing "reference"
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
    
    
    
    //start typing supplementary
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //declare Header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! profileHeader
        header.delegate = self       // Set the header cell to comform to the userProfileDelegate

        //Set user value of the header
        if let user = self.user {
           header.user = user
        }else if let userFromSearch = userPassedFromSearch {
            header.user = userFromSearch
            navigationItem.title = userFromSearch.username
        }
        return header
    }
    

    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) 
        return cell
    }
    
    
    
    
    
    
    
    //MARK : - HANDLERS
    @objc func buttonTapped(for header: profileHeader) {
        print("users are the most important elements in the growth of this world!")
 
    }
    
    
    
    
    
    
    
    //MARK: - API
    func fetchCurrentUserData(){
        //To get data on the current user, first get the user's uid
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        let userData = Database.database().reference().child("users").child(currentUserUid)
        
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

