//
//  ShineNetworkService.swift
//  OneDance
//
//  Created by Burak Can on 10/7/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import AWSCore
import AWSS3
import AWSCognito


struct ShineNetworkService {
    
    private struct Constants {
        
        static let baseUrl : String = "https://cczx1tdm50.execute-api.us-east-1.amazonaws.com/PROD/"
        
        // User
        static let deviceUrl : String = baseUrl + "devices"
        static let userUrl : String = baseUrl + "users"
        static let registerUserUrl : String = userUrl
        static let emailLoginUrl : String = userUrl + "/login"
        
        static let getDanceTypesUrl : String = baseUrl + "dancetypes"
        static let updateDanceTypesUrl : String = userUrl + "/me" + "/dancetypes"
        //static let updateDanceTypesUrl : String = userUrl + PersistanceManager.User.userId! + "/dancetypes"
        
        
        static func getUserProfileUrl(otherUserID: String) -> String {
            return userUrl + "/" + otherUserID + "/profile"
        }
        static let getMyProfileUrl : String = userUrl + "/me" + "/profile"
        static let updateUserProfileUrl : String = getMyProfileUrl
        static let changeProfilePhotoUrl : String = userUrl + "/me" + "/profile" + "/photo"
        
        struct Organization {
            private static let base : String = baseUrl + "organizations"
            static let createUrl : String = base
            static func getChangePhotoUrl(id: String) -> String {
                
                let url : String = Organization.base + "/\(id)" + "/photo"
                return url
                
            }
        }
        
        struct Event {
            private static let base : String = baseUrl + "events"
            static let createUrl : String = base
            static func getChangePhotoUrl(id: String) -> String {
                
                let url : String = Event.base + "/\(id)" + "/photo"
                return url
            
            }
        }
        
        struct Feed {
            static let myFeedUrl : String = baseUrl + "users/me/feed"
        }
        
        struct AWS3 {
            static let identityPoolId = "us-east-1:47270df4-2548-48b3-9625-25d30ee060ef"
            static let regionType = AWSRegionType.USEast1
            
            static let S3BucketName: String = "shinemedia" // Update this to your bucket name
            
            static let uploadKeyNameForProfileImage : String = "profile-image.png"
            static let downloadKeyNameForProfileImage : String = "profile-image.png"
        }
        
    }
    
    struct S3 {
        static func configureAWS(){
            
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: Constants.AWS3.regionType, identityPoolId: Constants.AWS3.identityPoolId)
            let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration
        }
        
        static func uploadProfilePhoto(with data: Data, progressBlock: AWSS3TransferUtilityProgressBlock?, completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?, continueWithHandler : @escaping (AWSTask<AWSS3TransferUtilityUploadTask>) -> Any?){
            print("#############################################################")
            print(" ---------  S3.uploadProfilePhoto() ---------------------------")
            let transferUtility = AWSS3TransferUtility.default()
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = progressBlock
            
            transferUtility.uploadData(
                data,
                bucket: Constants.AWS3.S3BucketName,
                key: Constants.AWS3.uploadKeyNameForProfileImage,
                contentType: "image/png",
                expression: expression,
                completionHandler: completionHandler)
            
            API.User.changeProfilePhoto()
            
        }
        
    }
    
    struct API {
        private struct Helper {
            static func debugResponse(methodName: String, response: DataResponse<Any>) {
                // You are now running on the concurrent `queue` you created earlier.
                print("#############################################################")
                print(" --------- \(methodName) ---------------------------")
                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                debugPrint(response)
                print("============")
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
            }
        }
        
        struct Organization {
            
            static func create(model: OrganizationModel, mainThreadCompletionHandler: @escaping (_ error: NSError?, _ orgId: String?) ->()) {
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "USER-ID": PersistanceManager.User.userId!
                ]
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(Constants.Organization.createUrl, method: .post,parameters: model.jsonData, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            
                            // Debug
                            Helper.debugResponse(methodName: "createOrganization()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = nil
                            guard response.result.isSuccess else {
                                
                                error = ErrorFactory.createForAlamofireResponse(with: httpStatusCode!)
                                mainThreadCompletionHandler(error, nil)
                                print("Error 1")
                                return
                            }
                            // serialized json response
                            guard let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] else{
                                error = ErrorFactory.createForResponseDataSerialization(with: httpStatusCode!)
                                mainThreadCompletionHandler(error, nil)
                                print("Error 2")
                                return
                            }
                            
                            guard let organizationModel = OrganizationModel(json: jsonDict) else {
                                
                                if let errorMessage = jsonDict["message"] as? String{
                                    error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                    print("Error 3")
                                    
                                } else {
                                    error = ErrorFactory.create(.Network, .Network, .DataJSONSerialization)
                                    print("Error 4")
                                    
                                }
                                
                                mainThreadCompletionHandler(error, nil)
                                return
                                
                            }
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                            }
                            
                            //
                            // To update anything on the main thread, just jump back on like so.
                            mainThreadCompletionHandler(error, organizationModel.id)
                    }
                )
            } // createOrganization
            
            static func changeOrganizationPhoto(orgId: String, uploadKeyName: String, mainThreadCompletionHandler: @escaping(_ error: NSError?) -> ()){
                
                let parameters : Parameters = [
                    "name" : uploadKeyName,
                    "photo" : true
                ]
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "USER-ID": PersistanceManager.User.userId!
                ]
                
                let url = Constants.Organization.getChangePhotoUrl(id: orgId)
                
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(url, method: .put,parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            
                            // Debug
                            Helper.debugResponse(methodName: "OrganizationImage.create()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = nil
                            guard response.result.isSuccess else {
                                
                                error = ErrorFactory.createForAlamofireResponse(with: httpStatusCode!)
                                mainThreadCompletionHandler(error)
                                print("Error 1")
                                return
                            }
                            // serialized json response
                            guard let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] else{
                                error = ErrorFactory.createForResponseDataSerialization(with: httpStatusCode!)
                                mainThreadCompletionHandler(error)
                                print("Error 2")
                                return
                            }
                            
                            guard let imageModel = MediaImage(json: jsonDict) else {
                                
                                if let errorMessage = jsonDict["message"] as? String{
                                    error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                    print("Error 3")
                                    
                                } else {
                                    error = ErrorFactory.create(.Network, .Network, .DataJSONSerialization)
                                    print("Error 4")
                                    
                                }
                                
                                mainThreadCompletionHandler(error)
                                return
                                
                            }
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                            }
                            
                            print("Event image created")
                            
                            //
                            // To update anything on the main thread, just jump back on like so.
                            mainThreadCompletionHandler(error)
                    }
                )
            } //changeEventPhoto
        }
        
        struct Event {
            
            static func create(model: EventModel, mainThreadCompletionHandler: @escaping (_ error: NSError?, _ eventId: String?) ->()) {
                
                //TODO: Consider event created by organization
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "USER-ID": PersistanceManager.User.userId!
                ]
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(Constants.Event.createUrl, method: .post,parameters: model.jsonData, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            
                            // Debug
                            Helper.debugResponse(methodName: "Event.create()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = nil
                            guard response.result.isSuccess else {
                                
                                error = ErrorFactory.createForAlamofireResponse(with: httpStatusCode!)
                                mainThreadCompletionHandler(error, nil)
                                print("Error 1")
                                return
                            }
                            // serialized json response
                            guard let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] else{
                                error = ErrorFactory.createForResponseDataSerialization(with: httpStatusCode!)
                                mainThreadCompletionHandler(error, nil)
                                print("Error 2")
                                return
                            }
                            
                            guard let eventModel = EventModel(json: jsonDict) else {
                                
                                if let errorMessage = jsonDict["message"] as? String{
                                    error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                    print("Error 3")
                                    
                                } else {
                                    error = ErrorFactory.create(.Network, .Network, .DataJSONSerialization)
                                    print("Error 4")
                                    
                                }
                                
                                mainThreadCompletionHandler(error, nil)
                                return
                                
                            }
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                            }
                            
                            print("Event created id: \(String(describing: eventModel.id))")
                            //
                            // To update anything on the main thread, just jump back on like so.
                            mainThreadCompletionHandler(error, eventModel.id)
                    }
                )
            } // createEvent
            
            static func changeEventPhoto(eventId: String, uploadKeyName: String, mainThreadCompletionHandler: @escaping(_ error: NSError?) -> ()){
                
                let parameters : Parameters = [
                    "name" : uploadKeyName,
                    "photo" : true
                ]
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "USER-ID": PersistanceManager.User.userId!
                ]
                
                let url = Constants.Event.getChangePhotoUrl(id: eventId)
                
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(url, method: .put,parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            
                            // Debug
                            Helper.debugResponse(methodName: "EventImage.create()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = nil
                            guard response.result.isSuccess else {
                                
                                error = ErrorFactory.createForAlamofireResponse(with: httpStatusCode!)
                                mainThreadCompletionHandler(error)
                                print("Error 1")
                                return
                            }
                            // serialized json response
                            guard let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] else{
                                error = ErrorFactory.createForResponseDataSerialization(with: httpStatusCode!)
                                mainThreadCompletionHandler(error)
                                print("Error 2")
                                return
                            }
                            
                            guard let imageModel = MediaImage(json: jsonDict) else {
                                
                                if let errorMessage = jsonDict["message"] as? String{
                                    error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                    print("Error 3")
                                    
                                } else {
                                    error = ErrorFactory.create(.Network, .Network, .DataJSONSerialization)
                                    print("Error 4")
                                    
                                }
                                
                                mainThreadCompletionHandler(error)
                                return
                                
                            }
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                            }
                            
                            print("Event image created")
                            
                            //
                            // To update anything on the main thread, just jump back on like so.
                            mainThreadCompletionHandler(error)
                    }
                )
            } //changeEventPhoto
        }
        
        struct User {
            
            static func addDevice(){
                
                let device = DeviceInfo()
                
//                let parameters: Parameters = [
//                    "id": PersistanceManager.Device.id,
//                    "brand": PersistanceManager.Device.brand,
//                    "model": PersistanceManager.Device.model,
//                    "osVersion": PersistanceManager.Device.osVersion,
//                    "appVersion": PersistanceManager.Device.appVersion
//                ]
                
                var info = device.jsonData
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(Constants.deviceUrl, method: .post,parameters: device.jsonData, encoding: JSONEncoding.default)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            
                            // Debug
                            Helper.debugResponse(methodName: "addDevice()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError?
                            guard response.result.isSuccess else {
                                
                                error = ErrorFactory.createForAlamofireResponse(with: httpStatusCode!)
                                print("Error 1")
                                return
                            }
                            
                            guard let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] else{
                                error = ErrorFactory.createForResponseDataSerialization(with: httpStatusCode!)
                                print("Error 2")
                                return
                            }
                            
                            guard let userId = jsonDict["userId"] as? String else {
                                
                                if let errorMessage = jsonDict["message"] as? String{
                                    error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                    print("Error 3")
                                    
                                } else {
                                    error = ErrorFactory.create(.Network, .Network, .DataJSONSerialization)
                                    print("Error 4")
                                    
                                }
                                
                                return
                            }
                            
                            // Success
                            print("userId: \(userId)")
                            PersistanceManager.User.saveLoginCredentials(userId: userId, secretID: nil)
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                            }
                            
                    }
                )
                
            }
            
            static func createAccountWithEmail(model:RegistrationModel, mainThreadCompletionHandler: @escaping (_ error: NSError?) ->()){
                
                var parameters = model.jsonData
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(Constants.registerUserUrl, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            
                            // Debug
                            Helper.debugResponse(methodName: "createAccountWithEmail()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = nil
                            guard response.result.isSuccess else {
                                
                                error = ErrorFactory.createForAlamofireResponse(with: httpStatusCode!)
                                mainThreadCompletionHandler(error)
                                print("Error 1")
                                return
                            }
                                // serialized json response
                            guard let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] else{
                                error = ErrorFactory.createForResponseDataSerialization(with: httpStatusCode!)
                                mainThreadCompletionHandler(error)
                                print("Error 2")
                                return
                            }
                            
                            guard let userId = jsonDict["userId"] as? String, let secret = jsonDict["secret"] as? String else {
                                
                                if let errorMessage = jsonDict["message"] as? String{
                                    error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                    print("Error 3")
                                    
                                } else {
                                    error = ErrorFactory.create(.Network, .Network, .DataJSONSerialization)
                                    print("Error 4")
                                    
                                }
                                
                                mainThreadCompletionHandler(error)
                                return
                            }
                            
                            // Success
                            print("userId: \(userId)")
                            print("secret: \(secret)")
                            PersistanceManager.User.saveLoginCredentials(userId: userId, secretID: secret)
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                            }
                            
                            //
                            // To update anything on the main thread, just jump back on like so.
                            mainThreadCompletionHandler(error)
                    }
                )
            } // createAccountWithEmail
            
            static func loginUserWith(model: LoginModel, mainThreadCompletionHandler: @escaping (_ error: NSError?) ->()){
               
                var parameters = model.jsonData
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(Constants.emailLoginUrl, method: .post,parameters: model.jsonData, encoding: JSONEncoding.default)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            // Debug
                            Helper.debugResponse(methodName: "loginUserWithEmail()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = nil
                            guard response.result.isSuccess else {
                                
                                error = ErrorFactory.createForAlamofireResponse(with: httpStatusCode!)
                                mainThreadCompletionHandler(error)
                                print("Error 1")
                                return
                            }
                            // serialized json response
                            guard let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] else{
                                error = ErrorFactory.createForResponseDataSerialization(with: httpStatusCode!)
                                mainThreadCompletionHandler(error)
                                print("Error 2")
                                return
                            }
                            
                            guard let userId = jsonDict["userId"] as? String, let secret = jsonDict["secret"] as? String else {
                                
                                if let errorMessage = jsonDict["message"] as? String{
                                    error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                    print("Error 3")
                                    
                                } else {
                                    error = ErrorFactory.create(.Network, .Network, .DataJSONSerialization)
                                    print("Error 4")
                                    
                                }
                                
                                mainThreadCompletionHandler(error)
                                return
                            }
                            
                            
                            // Success
                            print("userId: \(userId)")
                            print("secret: \(secret)")
                            PersistanceManager.User.saveLoginCredentials(userId: userId, secretID: secret)
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                            }
                            
                            //
                            // To update anything on the main thread, just jump back on like so.
                            mainThreadCompletionHandler(error)
                            
                    }
                )
            } // Login with email
            
            static func getDanceTypes(mainThreadCompletionHandler: @escaping (_ error: NSError?, _ data: [IDanceType]?) ->()) {
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "USER-ID": PersistanceManager.User.userId!
                ]
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(Constants.getDanceTypesUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            
                            // Debug
                            Helper.debugResponse(methodName: "getDanceTypes()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = nil
                            guard response.result.isSuccess else {
                                
                                error = ErrorFactory.createForAlamofireResponse(with: httpStatusCode!)
                                print("Error 1")
                                mainThreadCompletionHandler(error, nil)
                                return
                            }
                            
                            // serialized json response
                            guard let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] else{
                                error = ErrorFactory.createForResponseDataSerialization(with: httpStatusCode!)
                                print("Error 2")
                                mainThreadCompletionHandler(error, nil)
                                return
                            }
                            
                            guard let danceTypes = jsonDict["danceTypes"] as? [[String:Any]] else {
                                
                                if let errorMessage = jsonDict["message"] as? String{
                                    error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                    print("Error 3")
                                    
                                } else {
                                    error = ErrorFactory.create(.Network, .Network, .DataJSONSerialization)
                                    print("Error 4")
                                    
                                }
                                mainThreadCompletionHandler(error, nil)
                                return
                            }
                            
                            // Sucess
                            var danceTypeItems = Array<IDanceType>()
                            for danceObj in danceTypes {
                                danceTypeItems.append(DanceType(json: danceObj)!)
                            }
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                            }
                            
                            //
                            // To update anything on the main thread, just jump back on like so.
                            mainThreadCompletionHandler(error, danceTypeItems)
                            print("#############################################################")
                            
                    }
                )
            }// GetDanceTypes
            
            static func update(danceTypes: [IDanceType], mainThreadCompletionHandler: @escaping (_ error: NSError?) ->()){
                
                var dances = [[String:String]]()
                for dance in danceTypes {
                    var dict = Dictionary<String,String>()
                    dict["id"] = String(dance.id)
                    dict["name"] = dance.name
                    dances.append(dict)
                }
                
                let parameters : Parameters = [
                    "selectedDanceTypes" : dances
                ]
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "USER-ID": PersistanceManager.User.userId!
                ]
                
                print(parameters)
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(Constants.updateDanceTypesUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            // Debug
                            Helper.debugResponse(methodName: "updateDanceTypes()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = ErrorFactory.createWith(httpStatusCode: httpStatusCode!)
                            
                            // If error exists, the message can be parsed from response
                            if error != nil {
                                if response.result.isSuccess, let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] {
                                    if let errorMessage = jsonDict["message"] as? String{
                                        error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                        print("Error 3")
                                    }
                                }
                            }
                            
                            
                            // Success
                            // NO RESPONSE DATA IS EXPECTED FROM THIS API CALL
                            mainThreadCompletionHandler(error)
                            
                            print("#############################################################")
                            
                    }
                )
                
            }// UpdateDanceTypes
            
            static func updateProfileWith(userName: String, slogan: String, link: String, mainThreadCompletionHandler: @escaping (_ error: NSError?) ->()){
                
                //TODO: UPdate this api
                
                let parameters : Parameters = [
                    "bio" : slogan,
                    "website" : link
                ]
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "USER-ID": PersistanceManager.User.userId!
                ]
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(Constants.updateUserProfileUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            // Debug
                            Helper.debugResponse(methodName: "updateProfileWith()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = ErrorFactory.createWith(httpStatusCode: httpStatusCode!)
                            
                            // If error exists, the message can be parsed from response
                            if error != nil {
                                if response.result.isSuccess, let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] {
                                    if let errorMessage = jsonDict["message"] as? String{
                                        error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                        print("Error 3")
                                    }
                                }
                            }
                            
                            
                            // Success
                            // NO RESPONSE DATA IS EXPECTED FROM THIS API CALL
                            mainThreadCompletionHandler(error)
                            
                            print("#############################################################")
                            
                    }
                )
                
            }// UpdateProfileWith
            
            static func getUserProfile(otherUserId: String, mainThreadCompletionHandler: @escaping (_ error: NSError?, _ userModel:UserModelType?) ->()) {
                
                let otherUserUrl = Constants.getUserProfileUrl(otherUserID: otherUserId)
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "USER-ID": PersistanceManager.User.userId!
                ]
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(otherUserUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            // Debug
                            Helper.debugResponse(methodName: "getUserProfile()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = nil
                            guard response.result.isSuccess else {
                                
                                error = ErrorFactory.createForAlamofireResponse(with: httpStatusCode!)
                                print("Error 1")
                                mainThreadCompletionHandler(error, nil)
                                return
                            }
                            
                            // serialized json response
                            guard let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] else{
                                error = ErrorFactory.createForResponseDataSerialization(with: httpStatusCode!)
                                print("Error 2")
                                mainThreadCompletionHandler(error, nil)
                                return
                            }
                            
                            if let errorMessage = jsonDict["message"] as? String {
                                error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                print("Error 3")
                                mainThreadCompletionHandler(error, nil)
                                return
                                
                            }
                            
                            let userModel : UserModelType? = UserModel(json: jsonDict)
                            
                            if userModel == nil {
                                error = ErrorFactory.createForResponseDataSerialization(with: nil)
                                print("Json data is not parsed successfully for the user profile model")
                                
                            } else {
                                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                    print("Data: \(utf8Text)") // original server data as UTF8 string
                                }
                            }
                            
                            
                            //
                            // To update anything on the main thread, just jump back on like so.
                            mainThreadCompletionHandler(error, userModel)
                            print("#############################################################")
                            
                    }
                )
            }//GetUserProfile
            
            static func getMyProfile(mainThreadCompletionHandler: @escaping (_ error: NSError?, _ userModel:UserModelType?) ->()) {
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "USER-ID": PersistanceManager.User.userId!
                ]

                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(Constants.getMyProfileUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            // Debug
                            Helper.debugResponse(methodName: "getMyProfile()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = nil
                            guard response.result.isSuccess else {
                                
                                error = ErrorFactory.createForAlamofireResponse(with: httpStatusCode!)
                                print("Error 1")
                                mainThreadCompletionHandler(error, nil)
                                return
                            }
                            
                            // serialized json response
                            guard let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] else{
                                error = ErrorFactory.createForResponseDataSerialization(with: httpStatusCode!)
                                print("Error 2")
                                mainThreadCompletionHandler(error, nil)
                                return
                            }
                            
                            if let errorMessage = jsonDict["message"] as? String {
                                error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                print("Error 3")
                                mainThreadCompletionHandler(error, nil)
                                return
                                
                            }
                            
                            let userModel : UserModelType? = UserModel(json: jsonDict)
                            
                            if userModel == nil {
                                error = ErrorFactory.createForResponseDataSerialization(with: nil)
                                print("Json data is not parsed successfully for the user profile model")
                                
                            } else {
                                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                    print("Data: \(utf8Text)") // original server data as UTF8 string
                                }
                            }
                            
                            
                            //
                            // To update anything on the main thread, just jump back on like so.
                            mainThreadCompletionHandler(error, userModel)
                            print("#############################################################")
                            
                    }
                )
            }//GetUserProfile
            
            static func getUserProfileImage(with url: String, mainThreadCompletionHandler: @escaping (_ error: NSError?, _ profileImage: UIImage?) ->()) {
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(url, method: .get)
                    .responseImage(
                        queue: queue,
                        completionHandler: { response in
                            // Debug
                           
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            let error : NSError? = ErrorFactory.createWith(httpStatusCode: httpStatusCode!)
                            
                            if error != nil {
                                mainThreadCompletionHandler(error, nil)
                            }
                            
                            
                            // Validate your JSON response and convert into model objects if necessary
                            if let image = response.result.value {
                                
                                // To update anything on the main thread, just jump back on like so.
                                mainThreadCompletionHandler(error, image)
                            }
                            print("#############################################################")
                            
                    }
                )
            }//getUserProfileImage
            
            static func changeProfilePhoto() {
                
                let parameters : Parameters = [
                    "name" : Constants.AWS3.uploadKeyNameForProfileImage,
                    "photo" : true
                ]
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "USER-ID": PersistanceManager.User.userId!
                ]
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(Constants.changeProfilePhotoUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            
                            // Debug
                            Helper.debugResponse(methodName: "changeProfilePhoto()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = ErrorFactory.createWith(httpStatusCode: httpStatusCode!)
                            
                            // If error exists, the message can be parsed from response
                            if error != nil {
                                if response.result.isSuccess, let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] {
                                    if let errorMessage = jsonDict["message"] as? String{
                                        error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                        print("Error 3")
                                    }
                                }
                            }
                            
                            
                            // Success
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                            }
                            
                            
                            print("#############################################################")
                    }
                )
            }//ChangeprofilePhoto

            
        } // User
        
        struct Feed {
            static func getMyFeed(nextPageKey: String, refresh: Bool, mainThreadCompletionHandler: @escaping (_ error: NSError?, _ feedListModel: FeedListModel?) -> ()){
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "USER-ID": PersistanceManager.User.userId!
                ]
                
                var url = Constants.Feed.myFeedUrl
                if !nextPageKey.isEmpty && !refresh {
                    url += "?n=" + nextPageKey
                }
                
                let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
                Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(
                        queue: queue,
                        completionHandler: { response in
                            // Debug
                            Helper.debugResponse(methodName: "getMyFeed()", response: response)
                            
                            // Check status code
                            let httpStatusCode = response.response?.statusCode
                            
                            // Error
                            var error : NSError? = nil
                            guard response.result.isSuccess else {
                                
                                error = ErrorFactory.createForAlamofireResponse(with: httpStatusCode!)
                                print("Error 1")
                                mainThreadCompletionHandler(error, nil)
                                return
                            }
                            
                            // serialized json response
                            guard let jsonData = response.result.value, let jsonDict = jsonData as? [String:Any] else{
                                error = ErrorFactory.createForResponseDataSerialization(with: httpStatusCode!)
                                print("Error 2")
                                mainThreadCompletionHandler(error, nil)
                                return
                            }
                            
                            if let errorMessage = jsonDict["message"] as? String {
                                error = ErrorFactory.create(.User, .User, .User, description: errorMessage)
                                print("Error 3")
                                mainThreadCompletionHandler(error, nil)
                                return
                                
                            }
                            
                            let feedModel = FeedListModel(json: jsonDict)
                            
                            if feedModel == nil {
                                error = ErrorFactory.createForResponseDataSerialization(with: nil)
                                print("Json data is not parsed successfully for the user profile model")
                                
                            }
                            
                            //
                            // To update anything on the main thread, just jump back on like so.
                            mainThreadCompletionHandler(error, feedModel)
                            print("#############################################################")
                            
                    }
                )
                
                
                
            }
        }
        
        
        
        
        
        
        
    }
    
}
