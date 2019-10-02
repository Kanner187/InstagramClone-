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
    var users = [User]()
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
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let followerCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowerCell
        followerCell.delegate = self
        followerCell.user = users[indexPath.row]
        
        return followerCell
    }

    
    //MARK: - FUNCTIONS
    
    
    
    
    //MARK:- HANDLERS
    func handleFollowButtonTapped(for cell: FollowerCell) {
        guard let user = cell.user else {return}
        if user.isFollowed{
            user.unfollow()
            cell.button.setTitle("Follow", for: .normal)
            cell.button.setTitleColor(.white, for: .normal)
            cell.button.layer.borderWidth = 0
            cell.button.backgroundColor = UIColor(displayP3Red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        }else{
            user.follow()
            cell.button.setTitle("Following", for: .normal)
            cell.button.setTitleColor(.black, for: .normal)
            cell.button.layer.borderWidth = 0.5
            cell.button.layer.borderColor = UIColor.lightGray.cgColor
            cell.button.backgroundColor = UIColor.white
        }
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
             let userId = snapshot.key
        
            usersReference.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String , Any> else { return }
                let user = User(uid: userId, dictionary: dictionary)
                self.users.append(user)
                
                self.tableView.reloadData()
            })
            
        }
        
        
           
        }
        
    }
    

