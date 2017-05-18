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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsLayout()
        view.setNeedsDisplay()
        fetchFlickrData()
    }
    
    func fetchFlickrData() {
        imageGalleryModel.fetchImageGalleryData(withCompletion: { 
            self.imageCount = self.imageGalleryModel.images.count
            self.loadingView.isHidden = true
        }, andFailure: {
            print("Failed to get images")
            self.loadingView.isHidden = false
            self.loadingViewLabel.text = "Failed To Get Images Please Try Again Later"
        })
    }
    
    @IBAction func filterItemsButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Sort Images", message: "Choose how to sort these images", preferredStyle: .alert)
        let dateTakenSortAction = UIAlertAction(title: "Date Taken", style: .default) { action in
            self.imageGalleryModel.images.sort {
                guard let dateTaken0 = $0.dateTaken, let dateTaken1 = $1.dateTaken else { return false }
                return dateTaken0 < dateTaken1
            }
            self.imageGalleryCollectionView.reloadData()
        }
        alertController.addAction(dateTakenSortAction)
        
        let datePublishedSortAction = UIAlertAction(title: "Date Published", style: .default) { action in
            self.imageGalleryModel.images.sort {
                guard let datePublished0 = $0.datePublished, let datePublished1 = $1.datePublished else { return false }
                return datePublished0 < datePublished1
            }
            self.imageGalleryCollectionView.reloadData()
        }
        alertController.addAction(datePublishedSortAction)
        
        let titleSortAction = UIAlertAction(title: "Title", style: .default) { action in
            self.imageGalleryModel.images.sort {
                guard let title0 = $0.title, let title1 = $1.title else { return false }
                return title0 < title1
            }
            self.imageGalleryCollectionView.reloadData()
        }
        alertController.addAction(titleSortAction)
        
        present(alertController, animated: true, completion: nil)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageGalleryDetailViewController") as! ImageGalleryDetailViewController
        
        detailVC.imageGalleryObject = imageGalleryModel.images[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ImageGalleryViewController: UICollectionViewDelegate {
    
}
