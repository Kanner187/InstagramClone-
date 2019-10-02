//
//  followVC.swift
//  instagramClone
//
//  Created by Levit Kanner on 01/10/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit
import Firebase

class followVC: UITableViewController, followerCellDelegate {

    // MARK: - PROPERTIES
    var viewFollowers = false
    var viewFollowing = false
    var uid : String? 
    
   private let reuseIdentifier : String = "followerCell"
    
    
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        fetchUsers()
        
        tableView.register(FollowerCell.self, forCellReuseIdentifier: reuseIdentifier)

        //configure navigation title
        if viewFollowers{
            self.navigationItem.title = "Followers"
        }else {
            self.navigationItem.title = "Following"
        }
        
        //Clear separator lines
        tableView.separatorColor = .clear
        
    }
    
    
    
    //MARK:- DELEGATE FUNCTIONS
    //configure tableview cell
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let followerCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowerCell
        followerCell.delegate = self
        return followerCell
    }
    
    
    //MARK: - FUNCTIONS
    
    
    
    
    //MARK:- HANDLERS
    func handleFollowButtonTapped(for cell: FollowerCell) {
        print("Button Tapped")
    }
    
    
    //MARK:- API
    func fetchUsers(){
        guard let uid = self.uid else { return }
        var ref:  DatabaseReference!
        
        if viewFollowers{
            //fetch followers
          ref = user_followers
    
        }else {
            //fetch following
            ref = user_following
        }
        
        ref.child(uid).observe(.childAdded) { (snapshot) in
            print(snapshot)
        }
        
        
           
        }
        
    }
    

