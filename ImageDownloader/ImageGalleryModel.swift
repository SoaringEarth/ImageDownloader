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
    
    static var sharedInstance = ImageGalleryModel()
    
    let appDelegate = AppDelegate()
    
    var images = [ImageGalleryObject]()
    
    func fetchImageGalleryData(withCompletion completionHandler: @escaping ()->(), andFailure failureHandler: @escaping ()->()) {
        
        if !coreDataObjectsExist() {
            print("Core Data Not Found:")
            WebServicesManager.sharedInstance.getImageDataWithCompletionBlock(completedWithSuccess: { (success, json) in
                if success {
                    for item in json["items"] {
                        if let itemDictionary = item.1.dictionary {
                            if !self.coreDataObjectExists(withTitle: itemDictionary["title"]!.stringValue) {
                                let imageGalleryObject = self.createImageGalleryObjectFrom(dictionary: itemDictionary)!
                                self.images.append(imageGalleryObject)
                                self.appDelegate.saveContext()
                            }
                        }
                    }
                    
                    completionHandler()
                } else {
                    print("Failed to get Data")
                    failureHandler()
                }
            })
        } else {
            completionHandler()
        }
    }
    
    private func coreDataObjectsExist() -> Bool {
        images = [ImageGalleryObject]()
        let entity = "ImageGalleryObject"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            if let entities = try appDelegate.persistentContainer.viewContext.fetch(request) as? [ImageGalleryObject] {
                for galleryObject in entities {
                    images.append(galleryObject)
                }
            }
        } catch {
            print("Error Searching for CoreData Objects")
            return false
        }
        
        if images.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    private func coreDataObjectExists(withTitle title : String) -> Bool {
        let entity = "ImageGalleryObject"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            if let entities = try appDelegate.persistentContainer.viewContext.fetch(request) as? [ImageGalleryObject] {
                print(entities.count)
                for galleryObject in entities {
                    if galleryObject.title == title {
                        return true
                    }
                }
            }
        } catch {
            print("Error Searching for CoreData Objects")
        }
        
        return false
    }
    
    private func createImageGalleryObjectFrom(dictionary: [String: JSON]) -> ImageGalleryObject? {
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
    
    private func getGalleryImageData(from URLString : String) -> Data? {
        
        let imageUrl: URL = URL(string: URLString)!
        do {
            let imageData: Data = try Data(contentsOf: imageUrl)
            return imageData
        } catch {
            print("Failed to get imageData")
        }
        return nil
    }
}
