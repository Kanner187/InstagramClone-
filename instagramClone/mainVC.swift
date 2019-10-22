//
//  mainVC.swift
//  instagramClone
//
//  Created by Levit Kanner on 10/09/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit
import Firebase

class mainVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        // Set delegate.
        self.delegate = self
        
        super.viewDidLoad()
        configureVC()
 
        // current user validation
        checkIfUserIsLoggedIn()

    }

    
    
    // Function to configure view controllers that exist within the tab bar controller
    func configureVC(){
        
        // Feed controller
        let feedController = constructNavController(selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), rootViewController: feedVC(collectionViewLayout: UICollectionViewFlowLayout() ))
        
        // Search controller
        let searchController = constructNavController(selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"), rootViewController: searchVC(style: .plain))
        
        // Post controller
//        let postController = constructNavController(selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: uploadPostVC() )
        let selectVC = constructNavController(selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        
        // Notification controller
        let notificationControlller = constructNavController(selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"), rootViewController: notificationVC(style: .plain))

        // Profile controller
        let profileController = constructNavController(selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: userProfileVC(collectionViewLayout: UICollectionViewFlowLayout() ))
        
        viewControllers = [ feedController , searchController , selectVC , notificationControlller , profileController]
        
        tabBar.tintColor = .black
    }
    
    //Mark: - Tabbar Delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: selectImageVC)
            self.present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    
    
    
    //Handles the creation of navigation controllers
    func constructNavController(selectedImage : UIImage , unselectedImage : UIImage , rootViewController : UIViewController = UIViewController()) -> UINavigationController{
        //Construct nav controller
        let navController = UINavigationController(rootViewController: rootViewController) // sets the root view of the navigation controller
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        return navController
    }
    
    
    
    
    
    
    func checkIfUserIsLoggedIn(){
        
        //Checks if a user is logged in
        if Auth.auth().currentUser == nil {
            print("No user logged in")
            
            // Displays login controller when no user is logged in
            DispatchQueue.main.async {
                let loginController = loginVC()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
    }


}
