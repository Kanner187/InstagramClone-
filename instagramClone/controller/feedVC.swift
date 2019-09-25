//
//  feedVC.swift
//  instagramClone
//
//  Created by Levit Kanner on 10/09/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit
import Firebase


private let reuseIdentifier = "Cell"


class feedVC: UICollectionViewController {
    // MARK: properties
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .white
        
        configureLogoutButton()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
    //MARK: Handlers
    func configureLogoutButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    
    
    @objc func handleLogout(){
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            do{
               try Auth.auth().signOut()
                
                //Present login VC
                let loginController = loginVC()
                let navController = UINavigationController(rootViewController: loginController) // Embed login controller in a navigation controller
                self.present(navController, animated: true, completion: nil)      // present navigation controller with rootcontroller loginVC
                
            }catch{
               //handle error
                print("Failed to sign out!")
            }
        }
        
        //Add alert Action to alert Controller and present Alert controller when logout button is tapped.
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }


}
