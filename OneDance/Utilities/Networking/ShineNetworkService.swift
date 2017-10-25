//
//  ShineNetworkService.swift
//  OneDance
//
//  Created by Burak Can on 10/7/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import Alamofire


struct ShineNetworkService {
    
    private struct Constants {
        static let baseUrl : String = "https://n48v6ca143.execute-api.us-east-1.amazonaws.com/test/"
        static let registerUserUrl : String = baseUrl + "users"
        static let emailLoginUrl : String = baseUrl + "login"
        static let getDanceTypesUrl : String = baseUrl + "dancetypes"
        
    }
    
    struct API {
        
        static func createAccountWithEmail(name: String, surName: String, email: String, password: String, mainThreadCompletionHandler: @escaping (_ error: NSError?) ->()){
            
            let parameters: Parameters = [
                "fullname": name + " " + surName,
                "email": email,
                "password": password
            ]
            
            let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
            Alamofire.request(Constants.registerUserUrl, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON(
                    queue: queue,
                    completionHandler: { response in
                        // You are now running on the concurrent `queue` you created earlier.
                        print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                        debugPrint(response)
                        print("============")
                        print("Request: \(String(describing: response.request))")   // original url request
                        print("Response: \(String(describing: response.response))") // http url response
                        print("Result: \(response.result)")                         // response serialization result
                        
                        
                        // Server error
                        var error : NSError? = nil
                        guard response.result.isSuccess else {
                            
                            error = NSError(domain: "com.cheers.Shine.networkDomain",
                                            code: Int(EPERM),
                                            userInfo: [NSLocalizedDescriptionKey: "Server error"])
                            
                            mainThreadCompletionHandler(error)
                            return
                        }
                        
                        
                        
                        // Validate your JSON response and convert into model objects if necessary
                        if let json = response.result.value {
                            print("JSON: \(json)") // serialized json response                  
                            
                            if let jsonDict = json as? [String:AnyObject],
                                let errorMessage = jsonDict["errorMessage"] as? String{
                                error = NSError(domain: "com.cheers.Shine.userError",
                                                code: Int(EPERM),
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            }
                            
                        }
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)") // original server data as UTF8 string
                        }
                        
                        //
                        // To update anything on the main thread, just jump back on like so.
                        mainThreadCompletionHandler(error)

                }
            )
        }
    
        static func loginUserWith(email: String, password: String, mainThreadCompletionHandler: @escaping (_ error: NSError?) ->()){
            
            let parameters: Parameters = [
                "email": email,
                "password": password
            ]
            
            let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
            Alamofire.request(Constants.emailLoginUrl, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON(
                    queue: queue,
                    completionHandler: { response in
                        // You are now running on the concurrent `queue` you created earlier.
                        print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                        debugPrint(response)
                        print("============")
                        print("Request: \(String(describing: response.request))")   // original url request
                        print("Response: \(String(describing: response.response))") // http url response
                        print("Result: \(response.result)")                         // response serialization result
                        
                        
                        // Server error
                        var error : NSError? = nil
                        guard response.result.isSuccess else {
                            
                            error = NSError(domain: "com.cheers.Shine.networkDomain",
                                            code: Int(EPERM),
                                            userInfo: [NSLocalizedDescriptionKey: "Server error"])
                            
                            mainThreadCompletionHandler(error)
                            return
                        }
                        
                        
                        
                        // Validate your JSON response and convert into model objects if necessary
                        if let jsonData = response.result.value {
                            print("JSON: \(jsonData)") // serialized json response
                            
                            if let jsonDict = jsonData as? [String:AnyObject],
                                let errorMessage = jsonDict["errorMessage"] as? String{
                                error = NSError(domain: "com.cheers.Shine.userError",
                                                code: Int(EPERM),
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            }
                            
                            // TODO: Update this portion of the code based on the Login API change
                            if let jsonDict = jsonData as? [String:AnyObject] {
                                if let userId = jsonDict["userId"] as? String, let secret = jsonDict["secret"] as? String{
                                    print("userId: \(userId)")
                                    print("secret: \(secret)")
                                    PersistanceManager.User.saveLoginCredentials(userId: userId, secretID: secret)
                                }
                            }
                            
                        }
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)") // original server data as UTF8 string
                        }
                        
                        //
                        // To update anything on the main thread, just jump back on like so.
                        mainThreadCompletionHandler(error)
                        
                }
            )
        }
        
        static func getDanceTypes(mainThreadCompletionHandler: @escaping (_ error: NSError?, _ data: [IDanceType]?) ->()) {
           
            
            let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
            Alamofire.request(Constants.getDanceTypesUrl, method: .get, encoding: JSONEncoding.default)
                .responseJSON(
                    queue: queue,
                    completionHandler: { response in
                        // You are now running on the concurrent `queue` you created earlier.
                        print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                        debugPrint(response)
                        print("============")
                        print("Request: \(String(describing: response.request))")   // original url request
                        print("Response: \(String(describing: response.response))") // http url response
                        print("Result: \(response.result)")                         // response serialization result
                        
                        var danceTypeItems = Array<IDanceType>()
                        // Server error
                        var error : NSError? = nil
                        guard response.result.isSuccess else {
                            
                            error = NSError(domain: "com.cheers.Shine.networkDomain",
                                            code: Int(EPERM),
                                            userInfo: [NSLocalizedDescriptionKey: "Server error"])
                            
                            mainThreadCompletionHandler(error, danceTypeItems)
                            return
                        }
                        
                        
                        
                        // Validate your JSON response and convert into model objects if necessary
                        if let jsonData = response.result.value {
                            print("JSON: \(jsonData)") // serialized json response
                            
                            if let jsonDict = jsonData as? [String:AnyObject],
                                let errorMessage = jsonDict["errorMessage"] as? String{
                                error = NSError(domain: "com.cheers.Shine.userError",
                                                code: Int(EPERM),
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            }
                            
                            // TODO: Update this portion of the code based on the Login API change
                            if let jsonDict = jsonData as? [String:AnyObject] {
                                if let danceTypes = jsonDict["danceTypes"] as? [[String:AnyObject]]{
                                    
                                    
                                    for danceObj in danceTypes {
                                        if let danceId = danceObj["id"] as? String, let danceName = danceObj["name"] as? String{
                                            danceTypeItems.append(DanceType(name: danceName, id: Int(danceId)!))
                                        }
                                        else{
                                            error = NSError(domain: "com.cheers.Shine.userError",
                                                            code: Int(EPERM),
                                                            userInfo: [NSLocalizedDescriptionKey: "Data is not parsed successfully."])
                                            break
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)") // original server data as UTF8 string
                        }
                        
                        //
                        // To update anything on the main thread, just jump back on like so.
                        mainThreadCompletionHandler(error, danceTypeItems)
                        
                }
            )
        }
        
        static func update(danceTypes: [IDanceType], forUser userID: String, mainThreadCompletionHandler: @escaping (_ error: NSError?) ->()){
            
        }
    }
    
}
