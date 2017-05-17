//
//  ImageGalleryModel.swift
//  ImageDownloader
//
//  Created by apple on 17/05/2017.
//
//

import UIKit
import CoreData

class ImageGalleryModel: NSObject {
    let appDelegate = AppDelegate()
    
    
    func fetchImageGalleryData() {
        WebServicesManager.sharedInstance.getImageDataWithCompletionBlock(completedWithSuccess: { (success, json) in
            if success {
                for item in json["items"] {
                    if let itemDictionary = item.1.dictionary {
                        if !self.coreDataObjectExists(withTitle: itemDictionary["title"]!.stringValue) {
                            _ = self.createImageGalleryObjectFrom(dictionary: itemDictionary)
                        }
                    }
                }
            } else {
                print("Failed to get Data")
            }
        })
    }
    
    private func coreDataObjectExists(withTitle title : String) -> Bool {
        
        let entity = "ImageGalleryObject"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            if let entities = try appDelegate.persistentContainer.viewContext.fetch(request) as? [NSManagedObject] {
                for galleryObject in entities {
                    if galleryObject.value(forKey: "title") as! String == title {
                        return true
                    }
                }
            }
        } catch {
            print("Error Searching for CoreData Objects")
        }
        
        return false
    }
    
    private func createImageGalleryObjectFrom(dictionary: [String: JSON]) -> NSManagedObject? {
        let context = appDelegate.persistentContainer.viewContext
        if let imageObject = NSEntityDescription.insertNewObject(forEntityName: "ImageGalleryObject", into: context) as? ImageGalleryObject {
            
            if let imageTitle = dictionary["title"]?.stringValue {
                imageObject.title = imageTitle
            }
            
            if let imageTags = dictionary["tags"]?.stringValue {
                imageObject.tags = imageTags
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-mm-yyyy"
            
            if let imageDateTaken = dictionary["date_taken"]?.stringValue {
                imageObject.dateTaken = dateFormatter.date(from: imageDateTaken)
            }
            
            if let imageDatePublished = dictionary["published"]?.stringValue {
                imageObject.datePublished = dateFormatter.date(from: imageDatePublished)
            }
            
            if let imageURLString = dictionary["media"]?.dictionaryValue["m"]?.stringValue {
                imageObject.image = getGalleryImageData(from: imageURLString)
            }
            return imageObject
        }
        return nil
    }
    
    private func getGalleryImageData(from URLString : String) -> NSData? {
        
        let imageUrl:URL = URL(string: URLString)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        return imageData
    }
}
