//
//  ImageGalleryCollectionViewCell.swift
//  ImageDownloader
//
//  Created by apple on 16/05/2017.
//
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setupInterface(withGalleryObject galleryObject : ImageGalleryObject) {
        
        titleLabel.text = galleryObject.title ?? ""
        
        if let imageData = galleryObject.image {
            imageView.image = UIImage(data:imageData)
        }
    }
}
