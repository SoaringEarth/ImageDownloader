//
//  ImageGalleryViewController.swift
//  ImageDownloader
//
//  Created by apple on 16/05/2017.
//
//

import UIKit

class ImageGalleryViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFlickrData()
    }
    
    func fetchFlickrData() {
        
        WebServicesManager.sharedInstance.getImageDataWithCompletionBlock(completedWithSuccess: { (success, json) in
            if success {
                
                print(json)
//                for message in (json!["chats"] as! [[String:AnyObject]]) {
//                    let newMessage = Message(json: message)
//                }
            } else {
                let alertController = UIAlertController(title: "No Data", message: "Please try again later", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
}

extension ImageGalleryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageGalleryCell", for: indexPath)
        
        cell.backgroundColor = UIColor.red
        
        return cell
    }
}

extension ImageGalleryViewController: UICollectionViewDelegate {
    
}
