//
//  ImageGalleryViewController.swift
//  ImageDownloader
//
//  Created by apple on 16/05/2017.
//
//

import UIKit

class ImageGalleryViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingViewLabel: UILabel!
    @IBOutlet weak var imageGalleryCollectionView: UICollectionView!
    
    let imageGalleryModel = ImageGalleryModel.sharedInstance
    
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
        imageGalleryModel.fetchImageGalleryData(withCompletion: { 
            self.imageCount = self.imageGalleryModel.images.count
            self.loadingView.isHidden = true
        }, andFailure: {
            print("Failed to get images")
            
            self.loadingViewLabel.text = "Failed To Get Images Please Try Again Later"
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageGalleryCell", for: indexPath) as! ImageGalleryCollectionViewCell
        
        cell.setupInterface(withGalleryObject: imageGalleryModel.images[indexPath.row])
        
        return cell
    }
}

extension ImageGalleryViewController: UICollectionViewDelegate {
    
}
