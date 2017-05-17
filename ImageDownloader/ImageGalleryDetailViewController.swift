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
        let alertController = UIAlertController(title: "Save Image", message: "Would you like to save this image", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "NO", style: .destructive, handler: nil))
        
        let saveAction = UIAlertAction(title: "OK", style: .default) { action in
            UIImageWriteToSavedPhotosAlbum(self.objectImageView.image!, nil, nil, nil)
        }
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)        
    }
}

extension ImageGalleryDetailViewController : MFMailComposeViewControllerDelegate {
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        shareImage()
    }
    
    private func shareImage() {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Check out this image from Flickr - So Cool")
            mail.setMessageBody("", isHTML: true)
            mail.addAttachmentData(imageGalleryObject!.image!, mimeType: "", fileName: "\(imageGalleryObject?.title).png")
            
            present(mail, animated: true)
        } else {

            print("Failed to send email")
            let alertController = UIAlertController(title: "Cannot Send Mail", message: "Please try again later, maybe on a real device", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
