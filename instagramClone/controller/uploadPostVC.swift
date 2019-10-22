//
//  uploadPostVC.swift
//  instagramClone
//
//  Created by Levit Kanner on 10/09/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit

class uploadPostVC: UIViewController , UploadImageDelegate , UITextViewDelegate{


    //Mark: Properties
    
    var SelectedImage : UIImage?{
        didSet{
            PhotoSelected.image = self.SelectedImage
        }
    }
    
   let PhotoSelected : UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.backgroundColor = .lightGray
    return imageView
   }()
    
    let captionField : UITextView = {
        let caption = UITextView()
        caption.backgroundColor = UIColor.systemGroupedBackground 
        caption.font = UIFont.systemFont(ofSize: 14 )
        caption.textColor = UIColor.black
        return caption
    }()
    
    let uploadButton : UIButton = {
        let uploadBtn = UIButton(type: .system)
        uploadBtn.isEnabled = true
        uploadBtn.setTitle("UPLOAD", for: .normal)
        uploadBtn.setTitleColor(.white, for: .normal)
        uploadBtn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        uploadBtn.layer.cornerRadius = 5
        uploadBtn.isEnabled = false
        uploadBtn.addTarget(self, action: #selector(handleUpload), for: .touchUpInside)
        return uploadBtn
    }()
    
    
    
    //Mark: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        captionField.delegate = self
        
        view.addSubview(PhotoSelected)
        PhotoSelected.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 82, paddingBottom: 0, paddingRight: 0, paddingLeft: 5, width: 100, height: 100)
        
        view.addSubview(captionField)
        captionField.anchor(top: view.topAnchor, left: PhotoSelected.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 82, paddingBottom: 0, paddingRight: 5, paddingLeft: 15, width: 0, height: 100)
        
        view.addSubview(uploadButton)
        uploadButton.anchor(top: captionField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingBottom: 0, paddingRight: 10, paddingLeft: 10, width: 0, height: 40 )
        configureNavBar()
    }
    
    
    
    //Mark: - UITextView
    func textViewDidChange(_ textView: UITextView) {
        print("User is typing something as a caption!")
    }
    
    
    
    //Mark: Handlers
    func configureNavBar (){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleUpload))
    }
    
    @objc func handleUpload(){
        print("Uploaded the image successfully")
        guard
            let image = self.PhotoSelected.image ,
            let caption = self.captionField.text,
            let currentUID = currentUser?.uid
            else {return}
        print("The caption of the post is \(caption) by \(currentUID)")
    }

}
