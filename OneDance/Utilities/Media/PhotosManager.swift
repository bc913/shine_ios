//
//  PhotosManager.swift
//  OneDance
//
//  Created by Burak Can on 12/31/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import AWSCore
import AWSS3
import AWSCognito

extension UInt64 {
    
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
    
}

final class PhotoManager {
    
    // Can not be initialized explicitly
    private init (){}
    
    // static let instance = PhotoManager() // Another singleton way
    
    private static var photoManagerInstance : PhotoManager {
        let manager = PhotoManager()
        // Do some configuration
        return manager
    }
    
    class func instance() -> PhotoManager {
        return photoManagerInstance
    }
    
    let decodeQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.underlyingQueue = DispatchQueue(label: "com.Shine.imageDecoder", attributes: .concurrent)
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
    
    //MARK: - Image Downloading
    
    func retrieveImage(for url: String, completion: @escaping (UIImage) -> Void) -> ImageRequest {
        let queue = decodeQueue.underlyingQueue
        let request = Alamofire.request(url, method: .get)
        let imageRequest = ImageRequest(request: request)
        let serializer = DataRequest.imageResponseSerializer()
        imageRequest.request.response(queue: queue, responseSerializer: serializer) { response in
            guard let image = response.result.value else { return }
            imageRequest.decodeOperation = self.decode(image) { image in
                completion(image)
                self.cache(image, for: url)
            }
        }
        return imageRequest
    }
    
    //MARK: - Image Caching
    
    func cache(_ image: Image, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }
    
    func cachedImage(for url: String) -> Image? {
        return imageCache.image(withIdentifier: url)
    }
    
    //MARK: - Image Decoding
    
    func decode(_ image: UIImage, completion: @escaping (UIImage) -> Void) -> DecodeOperation {
        let operation = DecodeOperation(image: image, completion: completion)
        decodeQueue.addOperation(operation)
        return operation
    }
    
    // MARK: - Image Uploading
    private struct Constants {
        struct AWS3 {
            static let identityPoolId = "us-east-1:47270df4-2548-48b3-9625-25d30ee060ef"
            static let regionType = AWSRegionType.USEast1
            
            static let S3BucketName: String = "shinemedia" // Update this to your bucket name
            
            static let uploadKeyNameForProfileImage : String = "profile-image.png"
            static let downloadKeyNameForProfileImage : String = "profile-image.png"
            
            static let uploadKeyNameForEventImage : String = "event-image.png"
            static let uploadKeyNameForOrganizationImage : String = "org-image.png"
        }
    }
    
    
    func configureAWS(){
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: Constants.AWS3.regionType, identityPoolId: Constants.AWS3.identityPoolId)
        let configuration = AWSServiceConfiguration(region: Constants.AWS3.regionType, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func uploadProfilePhoto(with data: Data, progressBlock: AWSS3TransferUtilityProgressBlock?, completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?, continueWithHandler : @escaping (AWSTask<AWSS3TransferUtilityUploadTask>) -> Any?){
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
        
        ShineNetworkService.API.User.changeProfilePhoto()
        
    }
    
    func uploadCreateEventImage(with data: Data, eventId: String, progressBlock: AWSS3TransferUtilityProgressBlock?, completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?, shineCompletionHandler: @escaping(_ error: NSError?) -> ()){
        print("#############################################################")
        print(" ---------  S3.uploadCreateEventImage() ---------------------")
        let transferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock
        
        transferUtility.uploadData(
            data,
            bucket: Constants.AWS3.S3BucketName,
            key: Constants.AWS3.uploadKeyNameForEventImage,
            contentType: "image/png",
            expression: expression,
            completionHandler: completionHandler)
        
        ShineNetworkService.API.Event.changeEventPhoto(eventId: eventId, uploadKeyName: Constants.AWS3.uploadKeyNameForEventImage, mainThreadCompletionHandler: shineCompletionHandler)
    }
    
    func uploadOrganizationImage(with data: Data, orgId: String, progressBlock: AWSS3TransferUtilityProgressBlock?, completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?, shineCompletionHandler: @escaping(_ error: NSError?) -> ()){
        print("#############################################################")
        print(" ---------  S3.uploadCreateEventImage() ---------------------")
        let transferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock
        
        transferUtility.uploadData(
            data,
            bucket: Constants.AWS3.S3BucketName,
            key: Constants.AWS3.uploadKeyNameForEventImage,
            contentType: "image/png",
            expression: expression,
            completionHandler: completionHandler)
        
        ShineNetworkService.API.Organization.changeOrganizationPhoto(orgId: orgId, uploadKeyName: Constants.AWS3.uploadKeyNameForEventImage, mainThreadCompletionHandler: shineCompletionHandler)
    }
    
    
}
