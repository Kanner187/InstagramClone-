//
//  searchUserCell.swift
//  instagramClone
//
//  Created by Levit Kanner on 14/09/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit

class searchUserCell: UITableViewCell {
    var user : User?{
        didSet{
            guard  let imageUrl = user?.profileImageURL else {return}
            guard  let username = user?.username else {return}
            guard let fullname = user?.fullname else {return}
            
            profileImageView.loadImage(with: imageUrl)
            self.textLabel?.text = username
            self.detailTextLabel?.text = fullname
        }
    }
    
    //Mark : Properties
    let profileImageView : UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.backgroundColor = UIColor.lightGray
        return piv
    }()

    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        // Add subviews
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingRight: 0, paddingLeft: 5, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 68, y: (textLabel?.frame.origin.y)!-2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        detailTextLabel?.frame = CGRect(x: 68, y: (detailTextLabel?.frame.origin.y)!, width: (self.frame.width)-108, height: (detailTextLabel?.frame.height)!)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel?.textColor = UIColor.lightGray
    }
    
    
}
