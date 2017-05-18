//
//  WebServicesManager.swift
//  ImageDownloader
//
//  Created by Jonathon Albert
//
//

import Foundation

class WebServicesManager: NSObject {
    static let sharedInstance = WebServicesManager()
}

// MARK: - Get ImageData from
extension WebServicesManager {
    
    func getImageDataWithCompletionBlock(completedWithSuccess : @escaping (_ success : Bool, _ jsonData : JSON)->()) {
        
        let flickrURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&jsoncallback=?"
        
        APIManager.request(url: flickrURL, method:.POST, useCaching: true, completion: { (success, json) in
            if let nonNilJSON = json {
                return completedWithSuccess(true, nonNilJSON)
            }
        }, failure: { (data, error) in
            print("getImageDataWithCompletionBlock: \(error)")
            return completedWithSuccess(false, JSON.null)
        })
    }
}

