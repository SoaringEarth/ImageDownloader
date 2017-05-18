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
        
        var galleryObjects : [ImageGalleryObject]?
    
        guard let jsonData = loadJSONFromTestsFile() else { XCTFail(); return }
        
        XCTAssert(jsonData != JSON.null)
    
        for item in jsonData["items"] {
        
            let galleryObject = ImageGalleryModel.sharedInstance.createImageGalleryObjectFrom(dictionary: item.1)
            
            XCTAssert(galleryObject != nil)
            galleryObjects?.append(galleryObject!)
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
