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
    
    //MARK:- Properties
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
    
    
    //MARK: - Views
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    lazy var nameLabel : UILabel = {
        let nl = UILabel()
        nl.font = UIFont.boldSystemFont(ofSize: 13)
        nl.contentMode = .center
        return nl
    }()
    
   lazy var postLabel : UILabel = {
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
    
    lazy var followersLabel : UILabel = {
        let fl = UILabel()
        fl.numberOfLines = 0
        fl.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        let postString = NSAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) ,NSAttributedString.Key.foregroundColor : UIColor.black ])
        attributedText.append(postString)
        fl.attributedText = attributedText
        //Add tap gesture recognizer
        let followersTap = UITapGestureRecognizer(target: self , action: #selector(handleFollowersTapped))
        followersTap.numberOfTapsRequired = 1
        fl.isUserInteractionEnabled = true
        fl.addGestureRecognizer(followersTap)
        return fl
    }()
    
    lazy var followingLabel : UILabel = {
        let fl = UILabel()
        fl.numberOfLines = 0
        fl.textAlignment = .center
        //Add attributed Text
        let attributedText = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        let postString = NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) ,NSAttributedString.Key.foregroundColor : UIColor.black ])
        attributedText.append(postString)
        fl.attributedText = attributedText
        //Add tapRecognizer
        let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(handleFollowingTapped))
        tapRecognizer.numberOfTapsRequired = 1
        fl.isUserInteractionEnabled = true
        fl.addGestureRecognizer(tapRecognizer)
        return fl
    }()

    lazy var gridButton : UIButton = {
        let gridButton = UIButton(type: .system)
        gridButton.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        gridButton.tintColor = UIColor.lightGray
        return gridButton
    }()
    
    lazy var listButton : UIButton = {
        let listButton = UIButton(type: .system)
        listButton.setImage( #imageLiteral(resourceName: "list"), for: .normal)
        listButton.tintColor = UIColor.lightGray
        return listButton
    }()
    
   lazy var bookmarkButton : UIButton = {
        let bookmarkButton = UIButton(type: .system)
        bookmarkButton.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        bookmarkButton.tintColor = UIColor.lightGray
        return bookmarkButton
    }()
    
    lazy var editProfileFollowButton : UIButton = {
        let editButton = UIButton(type: .system)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        editButton.layer.borderWidth = 0.5
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.tintColor = UIColor.black
        editButton.layer.cornerRadius = 5
        editButton.addTarget(self , action: #selector(handleEditButtonTapped), for: .touchUpInside)
        editButton.setTitle("Loading", for: .normal)
        return editButton
    }()
    

    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingBottom: 0, paddingRight: 0, paddingLeft: 15, width: 90, height: 90)
        profileImageView.layer.cornerRadius = 90/2
        
        self.addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingBottom: 0, paddingRight: 0, paddingLeft: 15, width: 0, height: 0)
        
        configureLabels()
        
        self.addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: self.postLabel.bottomAnchor, left: self.profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 15, paddingBottom: 0, paddingRight: 10, paddingLeft: 10, width: 0, height: 30)
        configureBottomToolBar()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    
    //MARK: - Functions
    func configureLabels(){
        let stack = UIStackView(arrangedSubviews: [postLabel ,followersLabel ,followingLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
       self.addSubview(stack)
        stack.anchor(top: self.topAnchor, left: self.profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 18, paddingBottom: 0, paddingRight: 0, paddingLeft: 0, width: 0, height: 40)
    }
    
    func configureEditFollowButton (){
        delegate?.configureEditFollowButton(for: self)
    }
    
    //configure a stack view with the grid , list and bookmark buttons
    func configureBottomToolBar (){
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stack = UIStackView(arrangedSubviews: [self.gridButton , self.listButton , self.bookmarkButton])
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
        delegate?.setUserStats(for: self)
    }
    
    @objc func handleEditButtonTapped(){
        delegate?.handleEditButtonTapped(for: self)
    }
    
    
    
    // MARK: - Handlers
    @objc func handleFollowersTapped(){
        delegate?.handleFollowersTapped(for: self)
        
    }
    @objc func handleFollowingTapped (){
        delegate?.handleFollowingTapped(for: self)
    }
    
}
