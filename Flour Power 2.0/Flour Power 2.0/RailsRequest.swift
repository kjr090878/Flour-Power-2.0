//
//  ViewController.swift
//  Flour Power 2.0
//
//  Created by Kelly Robinson on 8/4/16.
//  Copyright © 2016 Kelly Robinson. All rights reserved.
//

import UIKit

private let _rr = RailsRequest()

private let _d = UserDefaults.standard

private let APIbaseURL = "https://flour-power.herokuapp.com"


class RailsRequest: NSObject {
    
    var recipes: [Recipe] = []
    
    
    class func session() -> RailsRequest { return _rr }
    
    var token: String? {
        
        get { return _d.object(forKey: "token") as? String }
        set { _d.set(newValue, forKey: "token") }
        
    }
    
    func loginWithEmail(_ email: String, andPassword password: String, completion: @escaping () -> ()) {
        
        var info = RequestInfo()
        
        info.endpoint = "/users"
        
        info.method = .POST
        
        info.parameters = [
            
            "email" : email as AnyObject,
            "password" : password as AnyObject
            
        ]
        
        requiredWithInfo(info) { (returnedInfo) -> () in
            
            if let key = returnedInfo?["auth_token"] as? String {
                
                self.token = key
                
                print(self.token)
                
            }
            
            if let errors = returnedInfo?["errors"] as? [String] {
                
            }
            
            completion()
            
        }
        
    }
    
    func registerWithEmail(_ email: String, andPassword password: String, completion: @escaping () -> ()) {
        
        var info = RequestInfo()
        
        info.endpoint = "/users/new"
        
        info.method = .POST
        
        info.parameters = [
            
            
            "password" : password as AnyObject,
            "email" : email as AnyObject
            
        ]
        
        requiredWithInfo(info) { (returnedInfo) -> () in
            
            if let key = returnedInfo?["auth_token"] as? String {
                
                self.token = key
                
                print(self.token)
                
            }
            
            if let errors = returnedInfo?["errors"] as? [String] {
                
            }
            
            completion()
            
        }
        
    }
    
    
    func requiredWithInfo(_ info: RequestInfo, completion: @escaping (_ returnedInfo: AnyObject?) -> ()) {
        
        let fullURLString = APIbaseURL + info.endpoint
        
        guard let url = URL(string: fullURLString) else { return } //add run completion with fail
        
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = info.method.rawValue
        
        
        if let token = token {
            
            request.setValue(token, forHTTPHeaderField: "auth-token")
            
                            print(token)
            
        }
        
        if info.parameters.count > 0 {
            
            if let requestData = try? JSONSerialization.data(withJSONObject: info.parameters, options: .prettyPrinted) {
                
                if let jsonString = NSString(data: requestData, encoding: String.Encoding.utf8.rawValue) {
                    
                    request.setValue("\(jsonString.length)", forHTTPHeaderField: "Content-Length")
                    
                    //possibly remove this line
                    let postData = jsonString.data(using: String.Encoding.ascii.rawValue, allowLossyConversion: true)
                    
                    request.httpBody = postData
                    
                }
                
            }
            
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //here we grab the access token & user id
        
        
        
        // add parameters to body
        
        //creates a task from request
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                
                if let data = data {
                    
                    
                    if let returnedInfo = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                        
                        completion(returnedInfo: returnedInfo)
                        
                    }
                    
                } else {
                    
                    //no data: check if error is not nil
                    
                }
                
                
            })
            
        }) 
        
        //runs the task (aka: makes the request call)
        task.resume()
    }
    
    
}

struct RequestInfo {
    
    enum MethodType: String {
        
        case POST, GET, DELETE, PATCH
    }
    
    var endpoint: String!
    var method: MethodType = .GET
    var parameters: [String:AnyObject] = [:]
    
}


