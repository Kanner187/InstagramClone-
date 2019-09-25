//
//  signupVC.swift
//  instagramClone
//
//  Created by Levit Kanner on 02/09/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit
import Firebase

class signupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userSelectedAnImage : Bool = false          // Tracks when a user selects an image as a profile picture.

    //  MARK : - VIEWS
    let photoButton : UIButton = {
        let photobtn = UIButton(type: .system)
        photobtn.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        photobtn.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        return photobtn
    }()
    
    let emailTextField : UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.font = UIFont.systemFont(ofSize: 14)
        emailField.backgroundColor = UIColor (white: 0, alpha: 0.03)
        emailField.autocorrectionType = UITextAutocorrectionType.no
        emailField.autocapitalizationType = UITextAutocapitalizationType.none
        emailField.addTarget(self , action: #selector(formValidation), for: .editingChanged) // This adds a target function to the text field
        return emailField
    }()
    
    let usernameTextField : UITextField = {
        let usernameField = UITextField()
        usernameField.placeholder = "Username"
        usernameField.borderStyle = .roundedRect
        usernameField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        usernameField.font = UIFont.systemFont(ofSize: 14)
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        usernameField.autocapitalizationType = UITextAutocapitalizationType.none
        usernameField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return usernameField
    }()
    
    let fullNameTextField : UITextField = {
        let fnField = UITextField()
        fnField.placeholder = "Fullname"
        fnField.borderStyle = .roundedRect
        fnField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        fnField.font = UIFont.systemFont(ofSize: 14)
        fnField.autocorrectionType = UITextAutocorrectionType.no
        fnField.autocapitalizationType = UITextAutocapitalizationType.none
        fnField.addTarget(self , action: #selector(formValidation), for: .editingChanged)
        return fnField
    }()
    
    let passwordTextField : UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        passwordField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        passwordField.font = UIFont.systemFont(ofSize: 14)
        passwordField.addTarget(self , action: #selector(formValidation), for: .editingChanged)
        return passwordField
    }()
    
    let signupButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("SIGNUP", for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false 
        button.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccount : UIButton = {
        let alreadyAccount = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) , NSAttributedString.Key.foregroundColor: UIColor.lightGray ])
        attributedTitle.append(NSMutableAttributedString(string: "Sign_in", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14) , NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)]))
        alreadyAccount.setAttributedTitle(attributedTitle, for: .normal)
        alreadyAccount.addTarget(self, action: #selector(alreadyHaveTapped), for: .touchUpInside)
        return alreadyAccount
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(photoButton)
        photoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingBottom: 0, paddingRight: 40, paddingLeft: 0, width: 140, height: 140)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true // Positions the photobutton at the center of the X axis.
        
        configureViews()       // This adds the stack view to the view controller
        
        view.addSubview(alreadyHaveAccount)
        alreadyHaveAccount.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 20, paddingRight: 30, paddingLeft: 20, width: 0, height: 40)
    }
    
    
    
    //MARK : - FUNCTIONS
    func configureViews(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField,fullNameTextField,usernameTextField,passwordTextField,signupButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.anchor(top: photoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingBottom: 0, paddingRight: 20, paddingLeft: 20, width: 0, height: 300)
    }
    

    
    
    
    
    //MARK : - HANDLERS
    @objc func photoButtonTapped() {
        let alertController = UIAlertController(title: "Choose Photo", message: "select photo media", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true  // This enable the editing of a picture by the image picker delegate
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    
    // Comform to the ImagePickerDelegate protocol
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Casts the selected image as a UIImage
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            userSelectedAnImage = false    // This is performed when a user doesn't select an image for a profile picture.
            return
        }
        userSelectedAnImage = true // This is set after the user selects an image as a profile picture
        
        //Configure photobutton with selected image
        photoButton.layer.cornerRadius = photoButton.frame.width/2 // This gives the button a circular shape
        photoButton.layer.masksToBounds = true
        photoButton.layer.borderColor = UIColor.black.cgColor
        photoButton.layer.borderWidth = 1
        photoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func formValidation(){
        guard emailTextField.hasText,
            passwordTextField.hasText,
            fullNameTextField.hasText,
            usernameTextField.hasText,
            userSelectedAnImage == true
            else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        signupButton.isEnabled = true
        signupButton.backgroundColor = UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)
    }
    
    
    @objc func createUser(){
        //Get properties
        guard
        let email = emailTextField.text ,
        let password = passwordTextField.text,
        let username = usernameTextField.text?.lowercased(),
        let fullName = fullNameTextField.text else {return}
        
        // 1. Creating a user. Import Firebase into the file
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            // Handles errors
            if let error = error {
                print("Failed", error.localizedDescription)
                return
            }
 
            //Working on profile picture
            guard let profileImage = self.photoButton.imageView?.image else {return}                    // Grab the image to be stored
            guard let compressedImage = profileImage.jpegData(compressionQuality: 0.5) else {return}   //Compress Image to able fast download.
            
            let filename = UUID().uuidString         //creates a unique identifier for each data to be uploaded into storage
            
            //Creates a storage space called "profile_images" and uploads the compressed image to it.
          let storageRef = Storage.storage().reference().child("profile_images").child(filename)      //Storage reference to where images will be stored
            
            
            //Puts the compressed image into storage
            storageRef.putData(compressedImage, metadata: nil, completion: { (metadata, error) in
                if let error = error{
                    print("Failed", error.localizedDescription)
                    return
                }
            
            //Get image url from firebase storage using the downloadUrl of the image to create a user profile in database
                storageRef.downloadURL(completion: { (url , error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }
                    guard let profileImageUrl = url?.absoluteString else {
                        print("Something went wrong!")
                        return
                    }
                    
                    //User dictionary
                    let userDictionary : [String : Any] = ["fullname" : fullName, "username" : username , "profileImageURL" : profileImageUrl]
                    
                    let uniqueUserID = user?.user.uid
                    let user = [uniqueUserID : userDictionary] // Assigns a user dictionary to a unique identifier.
                    

                    //Save user info to database
                    Database.database().reference().child("users").updateChildValues(user, withCompletionBlock: { (error, ref) in
                        //Handling error
                        if let error = error {
                            print("Failed to add to database ",error.localizedDescription)
                            return
                        }
                        // Handles success
                        print("Successfully created a user with Firebase")
                        
                        guard let mainvc = UIApplication.shared.keyWindow?.rootViewController as? mainVC else { return }
                        mainvc.configureVC()
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
    @objc func alreadyHaveTapped(){
        //This pops the view on the view stack ie. the signupVC
       navigationController?.popViewController(animated: true)
    }
}
