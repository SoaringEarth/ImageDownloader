//
//  ImageGalleryDetailViewController.swift
//  ImageDownloader
//
//  Created by apple on 17/05/2017.
//
//

import UIKit
import MessageUI

class ImageGalleryDetailViewController: UIViewController {
    
    @IBOutlet weak var objectImageView: UIImageView!
    @IBOutlet weak var objectTitleLabel: UILabel!
    @IBOutlet weak var objectTagsLabel: UILabel!
    @IBOutlet weak var objectPublishedLabel: UILabel!
    @IBOutlet weak var objectTakenLabel: UILabel!
    
    var imageGalleryObject : ImageGalleryObject? {
        didSet {
            setupInterface()
        }
    }
    
    private func setupInterface() {
        view.setNeedsLayout()
        
        if let imageData = imageGalleryObject?.image {
            objectImageView.image = UIImage(data:imageData)
        }
        
        if let objectTitle = imageGalleryObject?.title {
            objectTitleLabel.text = objectTitle
        }
        
        if let objectTags = imageGalleryObject?.tags {
            objectTagsLabel.text = objectTags
        }
        
        if let objectDatePublished = imageGalleryObject?.datePublished {
            objectPublishedLabel.text = String(describing: objectDatePublished)
        }
        
        if let objectDateTaken = imageGalleryObject?.dateTaken {
            objectTakenLabel.text = String(describing: objectDateTaken)
        }
    }
    
    
    
        
    }
}
