//
//  ImageGalleryViewController.swift
//  ImageDownloader
//
//  Created by apple on 16/05/2017.
//
//

import UIKit

class ImageGalleryViewController: UIViewController {
    
    @IBOutlet weak var imageGalleryCollectionView: UICollectionView!
    
    var imageCount = 0 {
        didSet {
            imageGalleryCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFlickrData()
    }
    
    func fetchFlickrData() {
        
        WebServicesManager.sharedInstance.getImageDataWithCompletionBlock(completedWithSuccess: { (success, json) in
            if success {
                for item in json["items"] {
                    print(item)
                }
                
                self.imageCount = json["items"].count
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
        return imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageGalleryCell", for: indexPath)
        
        cell.backgroundColor = UIColor.red
        
        return cell
    }
}

extension ImageGalleryViewController: UICollectionViewDelegate {
    
}
