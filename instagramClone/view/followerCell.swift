//
//  followerCell.swift
//  instagramClone
//
//  Created by Levit Kanner on 01/10/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit

class FollowerCell: UITableViewCell {
    var delegate : followerCellDelegate?
    var user : User? {
        didSet{
        }
    }
    
    lazy var userImage : UIImageView = {
        let UI = UIImageView()
        UI.contentMode = .scaleAspectFill
        UI.clipsToBounds = true
        UI.backgroundColor = UIColor.lightGray
        return UI
    }()
    
    lazy var button : UIButton = {
        let bt = UIButton(type: .system)
        bt.layer.borderWidth = 0.5
        bt.layer.borderColor = UIColor.lightGray.cgColor
        bt.setTitle("Loading", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = UIColor(displayP3Red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        bt.addTarget(self , action: #selector(handleFollowButtonTapped), for: .touchUpInside)
        bt.layer.cornerRadius = 5
        return bt
    }()
    
    
    
    //Mark: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(userImage)
        userImage.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingRight: 0, paddingLeft: 10, width: 48, height: 48)
        userImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userImage.layer.cornerRadius = 48/2
        
        addSubview(button)
        button.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingRight: 10, paddingLeft: 0, width: 90, height: 30)
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        textLabel?.text = "Username"
        detailTextLabel?.text = "Fullname"
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
    
    
    
    //MARK: - Handlers
    @objc func handleFollowButtonTapped(){
        delegate?.handleFollowButtonTapped(for: self)
    }
}
