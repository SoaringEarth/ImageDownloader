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
    
    func getImageDataWithCompletionBlock(completedWithSuccess : @escaping (_ success : Bool, _ jsonData : [String: Any]?)->()) {
        
        let flickrURL = "https://www.flickr.com/services/feeds/docs/photos_public"
        
        APIManager.request(url: flickrURL, method:.GET, completion: { (success, json) in
            if let nonNilJSON = json {
                return completedWithSuccess(true, nonNilJSON)
            }
        }, failure: { (data, error) in
            return completedWithSuccess(false, nil)
        })
    }
    
    func parserJSON(data: NSData) -> [AnyObject] {
        do {
            if let json = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [AnyObject] {
                return json
            }
        } catch {
            ///alert
            print(error)
            return []
        }
        
        return []
    }
}

