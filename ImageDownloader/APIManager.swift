//
//  APIManager.swift
//  ImageDownloader
//
//  Created by Jonathon Albert
//
//
// This is a stripped down version of an API Manager that I have designed and deployed to multiple projects
// This is a singleton for doing all API requests. It essentially manages a single NSURLSession.

import Foundation

class APIManager : NSObject, URLSessionDataDelegate {
    
    enum requestMethod : String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    static var sharedInstance = APIManager()
    var unauthenticatedSession : URLSession!
    
    override init () {
        super.init()
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .useProtocolCachePolicy
        config.timeoutIntervalForRequest = 120.0
        unauthenticatedSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    //MARK generic requests
    static func request(url:String, method:requestMethod, useCaching: Bool = false, valueToEncodeForKey:String? = nil, body:[String:String]? = nil, completion:((Bool, JSON?)->())?, failure:((NSData?, NSError)->())?) {
        
        _ = requestWithUrl(urlString: url, session:sharedInstance.unauthenticatedSession, method:method, body:body, useCaching: useCaching, valueToEncodeForKey:valueToEncodeForKey, completion:completion, failure:failure)
    }
    
    static func requestWithUrl(urlString:String, session:URLSession, method:requestMethod, body:[String:String]? = nil, useCaching: Bool = false, valueToEncodeForKey:String? = nil, completion:((Bool, JSON)->())?, failure:((NSData?, NSError)->())?) {
        
        let urlRequest = NSMutableURLRequest()
        urlRequest.httpMethod = method.rawValue
        if useCaching {
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        }
        else {
            urlRequest.cachePolicy = .useProtocolCachePolicy
        }
        
        let url : NSURL! = NSURL(string:urlString)
        
        urlRequest.url = url as URL?
        
        var dataTask: URLSessionDataTask!
        
        dataTask = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    failure?(data as NSData?, error! as NSError)
                    return
                }
                
                if let httpURLResponse = response as? HTTPURLResponse {
                    if (200...299 ~= httpURLResponse.statusCode) {
                        do {
                            if let data = data {
                                if var jsonPString = String(data: data, encoding: .utf8) {
                                    jsonPString.characters.removeFirst()
                                    jsonPString.characters.removeLast()
                                    
                                    let json = try JSON(data: (jsonPString.data(using: .utf8))!, options: [.allowFragments, .mutableContainers])
                                    completion!(true, json)
                                }
                            }
                        } catch {
                            ///alert
                            print(error)
                        }
                        
                    } else {
                        let httpError = NSError(domain: "HTTP Error", code: 1,
                                                userInfo: [NSLocalizedDescriptionKey:String(format:"Server error \(httpURLResponse.statusCode)")])
                        failure?(data! as NSData?, httpError)
                        print("failed request: \(urlString)")
                    }
                } else {
                    let responseError = NSError(domain: "Response Error", code: 3,
                                                userInfo: [NSLocalizedDescriptionKey:String(format:"No http response")])
                    failure?(data! as NSData?, responseError)
                }
            }
        })
        dataTask.resume()
    }
}
