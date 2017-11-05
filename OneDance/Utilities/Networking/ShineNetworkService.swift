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
        
        // USer
        static let userUrl : String = baseUrl + "users/"
        static let updateDanceTypesUrl : String = userUrl + PersistanceManager.User.userId! + "/dancetypes"
        static let updateProfileUrl : String = userUrl + PersistanceManager.User.userId! + "/profile"
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
                            
                            if let jsonDict = json as? [String:Any],
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
                            
                            if let jsonDict = jsonData as? [String:Any],
                                let errorMessage = jsonDict["errorMessage"] as? String{
                                error = NSError(domain: "com.cheers.Shine.userError",
                                                code: Int(EPERM),
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            }
                            
                            // TODO: Update this portion of the code based on the Login API change
                            if let jsonDict = jsonData as? [String:Any] {
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
                            
                            if let jsonDict = jsonData as? [String:Any],
                                let errorMessage = jsonDict["errorMessage"] as? String{
                                error = NSError(domain: "com.cheers.Shine.userError",
                                                code: Int(EPERM),
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            }
                            
                            // TODO: Update this portion of the code based on the Login API change
                            if let jsonDict = jsonData as? [String:Any] {
                                if let danceTypes = jsonDict["danceTypes"] as? [[String:Any]]{
                                    for danceObj in danceTypes {
                                        danceTypeItems.append(DanceType(json: danceObj)!)
                                    }
                                }
                                
                            } else{
                                error = NSError(domain: "com.cheers.Shine.userError",
                                                code: Int(EPERM),
                                                userInfo: [NSLocalizedDescriptionKey: "Data is not parsed successfully."])
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
        
        static func update(danceTypes: [IDanceType], mainThreadCompletionHandler: @escaping (_ error: NSError?) ->()){
            
            var dances = [[String:String]]()
            for dance in danceTypes {
                var dict = Dictionary<String,String>()
                dict["id"] = String(dance.id)
                dict["name"] = dance.name
                dances.append(dict)
            }
            
            let parameters : Parameters = [
                "danceTypes" : dances
            ]
            
//            let parameters : Parameters = [
//                "danceTypes" : [dances]
//            ]
            
            print(parameters)
            
            let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
            Alamofire.request(Constants.updateDanceTypesUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON(
                    queue: queue,
                    completionHandler: { response in
                        // You are now running on the concurrent `queue` you created earlier.
                        print("##########  UPDATE DANCE TYPES ########")
                        print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                        debugPrint(response)
                        print("============")
                        print("Request: \(String(describing: response.request))")   // original url request
                        print("Request body: \(String(describing: response.request?.httpBody))")
                        print("Response: \(String(describing: response.response))") // http url response
                        print("Result: \(response.result)")                         // response serialization result
                        
                        
                        // Server error
                        var error : NSError? = nil
                        
                        switch response.result {
                        case .success(let value):
                                print("BCSuccess:: \(value)")
                        case .failure(let error):
                                print("BCFAilure: \(error)")
                            
                        }
                        
//                        guard response.result.isSuccess else {
//                            let errorDescription = "Server error: " + "Status code: \(String(describing: response.response?.statusCode))"
//                            error = NSError(domain: "com.cheers.Shine.networkDomain",
//                                            code: Int(EPERM),
//                                            userInfo: [NSLocalizedDescriptionKey: errorDescription])
//                            
//                            mainThreadCompletionHandler(error)
//                            return
//                        }
                        print("updateDanceType status Code: \(String(describing: response.response?.statusCode))")
                        print("###############################")
                        // To update anything on the main thread, just jump back on like so.
                        mainThreadCompletionHandler(error)
                        
                }
            )
            
        }
        
        static func updateProfileWith(userName: String, slogan: String, link: String, mainThreadCompletionHandler: @escaping (_ error: NSError?) ->()){
            
            let parameters : Parameters = [
                "username" : userName,
                "bio" : slogan,
                "website" : link
            ]
            
            let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
            Alamofire.request(Constants.updateProfileUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON(
                    queue: queue,
                    completionHandler: { response in
                        // You are now running on the concurrent `queue` you created earlier.
                        print("##########  UPDATE DANCE TYPES ########")
                        print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                        debugPrint(response)
                        print("============")
                        print("Request: \(String(describing: response.request))")   // original url request
                        print("Request body: \(String(describing: response.request?.httpBody))")
                        print("Response: \(String(describing: response.response))") // http url response
                        print("Result: \(response.result)")                         // response serialization result
                        
                        
                        // Server error
                        var error : NSError? = nil
                        
                        switch response.result {
                        case .success(let value):
                            print("BCSuccess:: \(value)")
                        case .failure(let error):
                            print("BCFAilure: \(error)")
                            
                        }
                        
                        
                        //                        guard response.result.isSuccess else {
                        //                            let errorDescription = "Server error: " + "Status code: \(String(describing: response.response?.statusCode))"
                        //                            error = NSError(domain: "com.cheers.Shine.networkDomain",
                        //                                            code: Int(EPERM),
                        //                                            userInfo: [NSLocalizedDescriptionKey: errorDescription])
                        //
                        //                            mainThreadCompletionHandler(error)
                        //                            return
                        //                        }
                        print("updateDanceType status Code: \(String(describing: response.response?.statusCode))")
                        print("###############################")
                        // To update anything on the main thread, just jump back on like so.
                        mainThreadCompletionHandler(error)
                        
                }
            )
            
        }
        
        static func getUserProfile(mainThreadCompletionHandler: @escaping (_ error: NSError?, _ userModel:UserProfileModelType?) ->()) {
            
            
            let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
            Alamofire.request(Constants.profileUrl, method: .get, encoding: JSONEncoding.default)
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
                            
                            mainThreadCompletionHandler(error, nil)
                            return
                        }
                        
                        var userModel : UserProfileModelType?
                        
                        // Validate your JSON response and convert into model objects if necessary
                        if let jsonData = response.result.value {
                            print("JSON: \(jsonData)") // serialized json response
                            
                            if let jsonDict = jsonData as? [String:Any],
                                let errorMessage = jsonDict["errorMessage"] as? String{
                                error = NSError(domain: "com.cheers.Shine.userError",
                                                code: Int(EPERM),
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            }
                            
                            // TODO: Update this portion of the code based on the Login API change
                            
                            if let jsonDict = jsonData as? [String:Any] {
                                if let userProfile = jsonDict["userProfile"] as? [String:Any]{
                                    userModel = UserProfileModel(json: userProfile)
                                }
                                
                            } else{
                                error = NSError(domain: "com.cheers.Shine.userError",
                                                code: Int(EPERM),
                                                userInfo: [NSLocalizedDescriptionKey: "Data is not parsed successfully."])
                            }
                            
                        }
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)") // original server data as UTF8 string
                        }
                        
                        //
                        // To update anything on the main thread, just jump back on like so.
                        mainThreadCompletionHandler(error, userModel)
                        
                }
            )
        }
    }
    
}
