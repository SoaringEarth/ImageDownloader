//
//  ImageGalleryObject+CoreDataProperties.swift
//  ImageDownloader
//
//  Created by apple on 17/05/2017.
//
//

import Foundation
import CoreData


extension ImageGalleryObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageGalleryObject> {
        return NSFetchRequest<ImageGalleryObject>(entityName: "ImageGalleryObject");
    }

    @NSManaged public var title: String?
    @NSManaged public var tags: String?
    @NSManaged public var image: Data?
    @NSManaged public var datePublished: Date?
    @NSManaged public var dateTaken: Date?

}
