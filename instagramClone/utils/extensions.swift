//
//  extensions.swift
//  instagramClone
//
//  Created by Levit Kanner on 02/09/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit
import FirebaseDatabase

extension UIView {
    
    //Autolayout of components on a UIView controller
    func anchor(top: NSLayoutYAxisAnchor? , left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingBottom: CGFloat , paddingRight: CGFloat , paddingLeft: CGFloat, width: CGFloat , height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false //I don't really know what this line does in the function
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        // Negate the value of paddingBottom because of the direction of the padding.
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        //Negate the value of paddingRight because of the direction of the padding.
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}




//Create an image cache to prevent constant api calls to load images into the application
var ImageCache = [String : UIImage]()

extension UIImageView{
    //Loads picture from database if it hasn't already been loaded into the image cache
    func loadImage(with urlString : String){
        
        //Check if image already exists in image cache
        if let cachedImage = ImageCache[urlString] {
            self.image = cachedImage
            return
        }

        guard let urlString = URL(string: urlString) else {return}  // Casts the provided urlstring parameter to an actual URL
        
        //Get content of url
        URLSession.shared.dataTask(with: urlString) { (data , response , error) in
            //Handle error
            if let error = error {
                print("Failed to load image with error ",error.localizedDescription)
            }
            //Get image Data
            guard let imageData = data else { return }
            
            //Create an image out of the image data
            let image = UIImage(data: imageData)
            
            //Set key and value for image cache
            ImageCache[urlString.absoluteString] = image
            
            //Set image
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()  //The resume() after the urlsessions causes it to resume if it ever gets suspended.
    }
}

extension Database {
    static func fetchUser(with uid : String , completion : @escaping(User)-> ()){
        
        usersReference.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String , Any>  else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}

