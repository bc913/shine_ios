//
//  ImageRequest.swift
//  OneDance
//
//  Created by Burak Can on 1/1/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ImageRequest {
    
    var decodeOperation: Operation?
    var request: DataRequest
    
    init(request: DataRequest) {
        self.request = request
    }
    
    func cancel() {
        decodeOperation?.cancel()
        request.cancel()
    }
    
}
