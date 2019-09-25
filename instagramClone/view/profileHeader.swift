//
//  profileHeader.swift
//  instagramClone
//
//  Created by Levit Kanner on 11/09/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit
import Firebase


class profileHeader: UICollectionViewCell {
    var delegate : userProfileHeaderDelegate?
    
    var user : User?{
        didSet{
            configureEditFollowButton()
            
            //Set user Stats
            setUserStats(for: user)
            
            let fullname = user?.fullname
            nameLabel.text = fullname
            
            guard let profileImageUrl = user?.profileImageURL else { return }
            profileImageView.loadImage(with: profileImageUrl)
        }
    }
    
    //MARK : - VIEWS
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let nl = UILabel()
        nl.font = UIFont.boldSystemFont(ofSize: 13)
        nl.contentMode = .center
        return nl
    }()
    
    let postLabel : UILabel = {
        let pl = UILabel()
        pl.numberOfLines = 0       //Allows multiple lines of text
        //Declare two instances of an attributed text with font and color properties and appends them
        let attributedText = NSMutableAttributedString(string: "4\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        let postString = NSAttributedString(string: "Posts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) ,NSAttributedString.Key.foregroundColor : UIColor.black ])
        
        attributedText.append(postString)
        pl.attributedText = attributedText
        pl.textAlignment = .center
        return pl
    }()
    
    let followersLabel : UILabel = {
        let fl = UILabel()
        fl.numberOfLines = 0
        fl.textAlignment = .center
        return fl
    }()
    
    let followingLabel : UILabel = {
        let fl = UILabel()
        fl.numberOfLines = 0
        fl.textAlignment = .center
        return fl
    }()

    let gridButton : UIButton = {
        let gridButton = UIButton(type: .system)
        gridButton.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        gridButton.tintColor = UIColor.lightGray
        return gridButton
    }()
    
    let listButton : UIButton = {
        let listButton = UIButton(type: .system)
        listButton.setImage( #imageLiteral(resourceName: "list"), for: .normal)
        listButton.tintColor = UIColor.lightGray
        return listButton
    }()
    
    let bookmarkButton : UIButton = {
        let bookmarkButton = UIButton(type: .system)
        bookmarkButton.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        bookmarkButton.tintColor = UIColor.lightGray
        return bookmarkButton
    }()
    
    let editProfileFollowButton : UIButton = {
        let editButton = UIButton(type: .system)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        editButton.layer.borderWidth = 0.5
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.tintColor = UIColor.black
        editButton.layer.cornerRadius = 5
        return editButton
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingBottom: 0, paddingRight: 0, paddingLeft: 15, width: 90, height: 90)
        profileImageView.layer.cornerRadius = 90/2
        
        self.addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingBottom: 0, paddingRight: 0, paddingLeft: 15, width: 0, height: 0)
        
        configureLabels()
        
        self.addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 15, paddingBottom: 0, paddingRight: 10, paddingLeft: 10, width: 0, height: 30)
        
        configureBottomToolBar()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    //MARK : - FUNCTIONS
    func configureLabels(){
        let stack = UIStackView(arrangedSubviews: [postLabel , followersLabel , followingLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 18, paddingBottom: 0, paddingRight: 0, paddingLeft: 0, width: 0, height: 40)
    }
    
    
    func configureEditFollowButton (){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else {return}
        
        if uid == user.uid {
            //configure editFollowButton as edit button
            self.editProfileFollowButton.setTitle("Edit Profile", for: .normal)
        }else {
            user.checkIfUserIsFollowed { (followed) in
                if followed{
                    self.editProfileFollowButton.setTitle("Following", for: .normal)
                }else{
                    self.editProfileFollowButton.setTitle("Follow", for: .normal)
                }
                
            //configure edit button as follow button
                self.editProfileFollowButton.backgroundColor = UIColor(displayP3Red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
                self.editProfileFollowButton.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    
    //configure a stack view with the grid , list and bookmark buttons
    func configureBottomToolBar (){
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stack = UIStackView(arrangedSubviews: [gridButton , listButton , bookmarkButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        self.addSubview(stack)
        stack.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom:20, paddingRight: 10, paddingLeft: 10, width: 0, height: 50)
        
        self.addSubview(topDividerView)
        topDividerView.anchor(top: stack.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingRight: 0, paddingLeft: 0, width: 0, height: 0.5)
        
        self.addSubview(bottomDividerView)
        bottomDividerView.anchor(top: stack.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingRight: 0, paddingLeft: 0, width: 0, height: 0.5)
    }
    
    
    func setUserStats(for user : User?){
        var numberOfFollowers : Int!
        var numberOfFollowing : Int!
        
        guard let uid = user?.uid else { return }
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
            self.followingLabel.attributedText = attributedText
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
            self.followersLabel.attributedText = attributedText
        }
        
        //Get number of Posts
        
    }
    
    
    
    //  MARK : - Handlers
    @objc func handleEditButtonTapped(){
        print("button Tapped")
        if self.editProfileFollowButton.titleLabel?.text == "Edit Profile"{
            print("Handle edit user Profile")
            
        }else {
            if self.editProfileFollowButton.titleLabel?.text == "Follow"{
                editProfileFollowButton.setTitle("Following", for: .normal)
                user?.follow()
            }else{
                editProfileFollowButton.setTitle("Follow", for: .normal)
                user?.unfollow()
            }
        }
    }
    
    
    @objc func handleBookmark(_sender : UIButton){
        delegate?.buttonTapped(for: self)
    }
    
}
