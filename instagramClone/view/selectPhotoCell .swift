//
//  selectPhotoCell .swift
//  instagramClone
//
//  Created by Levit Kanner on 10/10/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit

class SelectPhotoCell : UICollectionViewCell{
    
    //Mark: - Properties
    let PhotoImage : UIImageView = {
           let pi = UIImageView()
           pi.backgroundColor = .lightGray
           pi.contentMode = .scaleAspectFill
           pi.clipsToBounds = true
           return pi
       }()
    
    //Mark: -Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.addSubview(PhotoImage)
        PhotoImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingRight: 0, paddingLeft: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
