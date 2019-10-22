//
//  SelectImageVC.swift
//  instagramClone
//
//  Created by Levit Kanner on 10/10/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit
import Photos

class SelectImageVC : UICollectionViewController, UICollectionViewDelegateFlowLayout , SelectImageDelegate {
  
    //Mark: - Properties
    private let reusableIdentifier = "cell"
    private let headerIdentifier = "header"
    
    var Images = [UIImage]()
    var Assets = [PHAsset]()
    var selectedImage : UIImage?
    
    //Mark: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //register collection view cell
        self.collectionView.register(SelectPhotoCell.self, forCellWithReuseIdentifier: reusableIdentifier)
        self.collectionView.register(SelectPhotoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        collectionView.backgroundColor = .white
        
        //Configure Navigation buttons
        configureNavigationButtons()
        
        //Fetch photos from photo library
        fetchPhotos()
    }
    
    
     
    
    //Mark: -UIcollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Images.count
    }
    
    
    
    
    //Mark: - UIcollectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 6) / 4
        return CGSize(width: width, height: width)
    }
    
    //Cell Spacing. Minimum Interim Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    
    
    
    //Mark: - Cell Configuration
    //Configure Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! SelectPhotoCell
        cell.PhotoImage.image = self.Images[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = Images[indexPath.row]
        self.collectionView.reloadData()
        
        let index = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: true)
    }
    
    
    // Configure Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SelectPhotoHeader
        
        //Set header cell image
        if let ImageSelected = self.selectedImage{
            //Index of selected Image
            if let index = self.Images.firstIndex(of: ImageSelected){
                //Asset associated with selectedImage
                let selectedAsset = self.Assets[index]
                let imageManger = PHImageManager.default()
                let targetSize = CGSize(width: 1000, height: 1000)
                
                //Request Image
                imageManger.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image , info) in
                    header.PhotoImage.image = image
                }
            }
        }
        return header
    }
    
    
    
    
    
    
    
    //Mark: - Delegate 
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil )
      }
    @objc func handleNext() {
        let uploadImageController = uploadPostVC()
        uploadImageController.SelectedImage = self.selectedImage
        navigationController?.pushViewController(uploadImageController, animated: true)
    }
    
    //Mark: - Handlers
    func configureNavigationButtons ( ){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .red
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    
    
    //Populate cells with Images in photo library
    func getAssetsFetchOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        
        //Fetch limit
        options.fetchLimit = 30
        
        //Sort Images by date
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        //Set sort descriptor for options
        options.sortDescriptors = [sortDescriptor]
        
        return options
    }
    
    
    
    func fetchPhotos (){
        let allPhotos = PHAsset.fetchAssets(with: .image, options:getAssetsFetchOptions() )
        
        //Fetch images on background thread
        DispatchQueue.global(qos: .background ).async {
            
            //Enumerate fetch results
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 1000, height: 1000)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                //request image representation for specified asset
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                    if let image = image {
                        //Append Image to data source
                        self.Images.append(image)
                        
                        //Append Assets to data source
                        self.Assets.append(asset)
                        
                        //Set selected image
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                        
                        //Reload collectionView once count is completed
                        if count == allPhotos.count - 1 {
                            //reload collectionView on main thread
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

