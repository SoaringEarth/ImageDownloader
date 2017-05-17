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
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveImage()
    }
    
    private func saveImage() {
        UIImageWriteToSavedPhotosAlbum(objectImageView.image!, nil, nil, nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        shareImage()
    }
    
    private func shareImage() {
        
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject("Check out this image from Flickr - So Cool")
        picker.setMessageBody("", isHTML: true)
        picker.addAttachmentData(imageGalleryObject!.image!, mimeType: "", fileName: "\(imageGalleryObject?.title).png")
        
        present(picker, animated: true, completion: nil)
    }
}

extension ImageGalleryDetailViewController : MFMailComposeViewControllerDelegate {
    
}
