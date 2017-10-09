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
    private let endPointUrl : String = "https://n48v6ca143.execute-api.us-east-1.amazonaws.com/test/users"
    
    init() {
        
    }
    
    func createAccountWithEmail(name: String, surName: String, email: String, password: String, mainThreadCompletionHandler: @escaping (_ error: NSError?) ->()){
        
        let parameters: Parameters = [
            "fullname": name + " " + surName,
            "email": email,
            "password": password
        ]
        
        let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
        Alamofire.request(endPointUrl, method: .post,parameters: parameters, encoding: JSONEncoding.default)
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
}
