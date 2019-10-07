//
//  loginVC.swift
//  instagramClone
//
//  Created by Levit Kanner on 02/09/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit
import Firebase

class loginVC: UIViewController {
    //Custom components
    //NB: Don't forget to invoke these custom components after declaring them.
    let logoContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingRight: 0, paddingLeft: 0, width: 200, height: 50)
        
        // The lines below centers the image view
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.addTarget(self , action: #selector(buttonActivation), for: .editingChanged)
        return tf
    }()
    
    let passwordTextfield : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(buttonActivation), for: .editingChanged)
        return tf
    }()
    
    let loginButton : UIButton = {
        let lb = UIButton(type: .system) // Determines the type of button which in this case is a system button.
        lb.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1) // Sets the color of the button
        lb.setTitle("LOGIN", for: .normal) // This sets the title of the button
        lb.setTitleColor(.white, for: .normal) // This sets the color of the button title
        lb.layer.cornerRadius = 5 // This sets the round edges of the button
        lb.isEnabled = false  // This disables the button until the required credentials are entered
        lb.addTarget(self , action: #selector(handleLogin), for: .touchUpInside)
        return lb
    }()
    
    let signupButton : UIButton = {
        let signupButton = UIButton(type: .system)
        //Configures the attributed string by specifing the font size and font color of the text
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?   ",attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) , NSAttributedString.Key.foregroundColor :UIColor.lightGray])
        //The line below appends the sign_up string to the "Don't have an account?" string
        attributedTitle.append(NSAttributedString(string: "Sign_up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)]))
        signupButton.setAttributedTitle(attributedTitle, for: .normal)
        
        signupButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return signupButton
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true //Hide navigation bar
        view.backgroundColor = .white // Added this line of code because the default background color of the view is black.
        
        view.addSubview(logoContainer)
        logoContainer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingRight: 0, paddingLeft: 0, width: 0, height: 150)
        
        configureViewComponents()
        
        view.addSubview(signupButton)
        signupButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 20, paddingRight: 20, paddingLeft: 20, width: 0, height: 40)
    }
    
    
    
    
    //A function that puts all the custom views into a stack view
    func configureViewComponents(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextfield, loginButton])
        
        // Define the properties of the stackView such as axis, spacing, distribution.
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        //Adds stack view to the view
        view.addSubview(stackView)
        stackView.anchor(top: logoContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingRight: 20, paddingLeft: 20, width: 0, height: 140)
    }
    
    
    //Button activation function
    @objc func buttonActivation(){
        guard emailTextField.hasText , passwordTextfield.hasText else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)
    }
    
    
    
    //Login function
    @objc func handleLogin(){
        guard let email = emailTextField.text , let password = passwordTextfield.text else {return}
        print(email , password)
        
        //sign user in with email and password
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // Handle success
            print("Successful signed user in")
            
            //Resets the mainVC as the rootview controller
            guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? mainVC else {return}
            mainTabVC.configureVC()     //Configure view controllers in the mainTab
            
            //Dismiss login VC
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    //Navigation to sign up page
    @objc func handleSignUp(){
        let signUpVC = signupVC()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}
