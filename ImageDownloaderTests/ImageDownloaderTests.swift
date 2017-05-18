//
//  ImageDownloaderTests.swift
//  ImageDownloaderTests
//
//  Created by apple on 17/05/2017.
//
//

import XCTest
@testable import ImageDownloader

class ImageDownloaderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // TODO: Create tests for Data Model
    func testSetupGalleryObjectsFromJSON() {
        
        // TODO: Fix Test
        
        let imageGalleryModel = ImageGalleryModel.sharedInstance
        
        var galleryObjects = [ImageGalleryObject]()
        
        guard let jsonData = loadJSONFromTestsFile() else { XCTFail(); return }
        
        XCTAssert(jsonData != JSON.null)
        
        for item in jsonData["items"] {
            
            let json = item.1
            
            guard let galleryObject = imageGalleryModel.createImageGalleryObjectFrom(dictionary: json) else { XCTFail(); break }
            
            XCTAssert(galleryObject.title != nil)
            XCTAssert(galleryObject.tags != nil)
            XCTAssert(galleryObject.dateTaken != nil)
            XCTAssert(galleryObject.datePublished != nil)
            XCTAssert(galleryObject.image != nil)
            
            galleryObjects.append(galleryObject)
        }
        
        if galleryObjects.count > 0 {
            XCTAssert( galleryObjects.count > 0)
        } else {
            XCTFail()
        }
    }
    
    func loadJSONFromTestsFile() -> JSON? {
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource: "Test", withExtension: "json")
        
        guard let data: Data = NSData(contentsOf: url!) as Data? else {return JSON.null}
        
        do {
            let object = try JSON(data: data, options: .allowFragments)
            let dictionary = object
            print(dictionary)
            return dictionary
        } catch  {
            print("Not parsed")
        }
        
        return JSON.null
    }
}
