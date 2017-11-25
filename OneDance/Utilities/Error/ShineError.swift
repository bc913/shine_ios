//
//  ShineError.swift
//  OneDance
//
//  Created by Burak Can on 11/23/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation

enum ShineErrorCode : UInt16 {
    // Network
    case NetworkRedirection // 3xx
    case NetworkClient // 4xx
    case NetworkServer //5xx
    case NetworkSerialization // Alaomifire.response.isSuccess
    
    // Data serialization
    case DataJSONSerialization // if the response data is not structured as expected
    
    // User
    case User
    
    // Device
    case Device
    
    // File
    case FileNotFound
    case FileExists
    
    case None
}

enum ShineErrorType {
    
    case Network
    case File
    case Database
    case User
    case Device
}

enum ShineErrorDomain : String {
    case Network  = "com.cheers.Shine.network"
    case File = "com.cheers.Shine.file"
    case Database = "com.cheers.Shine.database"
    case User = "com.cheers.Shine.user"
    case Device = "com.cheers.Shine.device"
}

struct ErrorFactory {
    
    static func create(_ errorType: ShineErrorType, _ domain: ShineErrorDomain, _ code: ShineErrorCode, description: String? = nil) -> NSError? {
        
        var error : NSError?
        
        guard description == nil else {
            
            error = NSError(domain: domain.rawValue,
                            code: Int(code.rawValue),
                            userInfo: [NSLocalizedDescriptionKey: description!])
            
            return error
        }
 
        var errorDescription : String
        switch code {
        
        case .NetworkRedirection:
            errorDescription = "Network HTTP Error: 3xx"
        case .NetworkClient:
            errorDescription = "Network HTTP Error: 4xx"
        case .NetworkServer:
            errorDescription = "Network HTTP Error 5xx"
        case .NetworkSerialization:
            errorDescription = "The response has no data or can not be serialized. Alamofire."
        case .DataJSONSerialization:
            errorDescription = "The data can not be parsed successfully. Check your API"
        case .User:
            errorDescription = "The user input is not successful."
        case .Device:
            errorDescription = "The device can not be registered"
        default:
            errorDescription = "Something went wrong"
        }
       
        error = NSError(domain: domain.rawValue,
                        code: Int(code.rawValue),
                        userInfo: [NSLocalizedDescriptionKey: errorDescription])
        
        /*
         userInfo = @{
         NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
         NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation timed out.", nil),
         NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
         };
         */
        
        return error
    }
    
    static func createWith(httpStatusCode: Int) -> NSError? {
        
        var errorCode : ShineErrorCode
        
        switch httpStatusCode {
        case 200..<300:
            errorCode = ShineErrorCode.None
            return nil
        case 300..<400:
            errorCode = ShineErrorCode.NetworkRedirection
        case 400..<500:
            errorCode = ShineErrorCode.NetworkClient
        case 500..<600:
            errorCode = ShineErrorCode.NetworkServer
        default:
            errorCode = ShineErrorCode.None
        }
        
        return create(.Network, .Network, errorCode)
    }
    
    static func createForAlamofireResponse(with httpStatusCode : Int? = nil) -> NSError? {
        // This is independent from http response status
        // Even if the response is successfull(2xx), the response data might be empty or non-serializable
        // This is sourced from Alamofire.response.isSuccess
        
        guard httpStatusCode == nil else {
            return create(.Network, .Network, .NetworkSerialization, description: "No serializable response data is returned. Status Code: \(httpStatusCode!)")
        }
        
        return create(.Network, .Network, .NetworkSerialization)
    }
    
    static func createForResponseDataSerialization(with httpStatusCode : Int? = nil) -> NSError?{
        // IF the response.data is returned but the json structure is not as expected, throw this error.
        
        guard httpStatusCode == nil else {
            return create(.Network, .Network, .DataJSONSerialization, description: "The returned data is not serializable. Status Code: \(httpStatusCode!)")
        }
        
        return create(.Network, .Network, .DataJSONSerialization)
    }
}
