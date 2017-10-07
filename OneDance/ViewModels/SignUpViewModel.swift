//
//  SignUpViewModel.swift
//  OneDance
//
//  Created by Burak Can on 10/1/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import Foundation
import Alamofire


class EmailSignUpViewModel: EmailSignUpViewModelType {
    
    weak var coordinatorDelegate: EmailSignUpViewModelCoordinatorDelegate?
    weak var viewDelegate: EmailSignUpViewModelViewDelegate?
    
    var userName: String = ""
    var userSurname: String = ""
    var email: String = ""
    var password: String = ""
    
    func submit() {
        print("EmailSignUpVM :: submit()")
        
        let parameters: Parameters = [
            "fullname": "Burak" + " " + "Can",
            "email": "basanh913@gmail.com",
            "password": "osman"
        ]
        
        let queue = DispatchQueue(label: "com.bc913.http-response-queue", qos: .background, attributes: [.concurrent])
        Alamofire.request("https://n48v6ca143.execute-api.us-east-1.amazonaws.com/test/users", method: .post,parameters: parameters, encoding: JSONEncoding.default)
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
                    
                    // Validate your JSON response and convert into model objects if necessary
                    if let json = response.result.value {
                        print("JSON: \(json)") // serialized json response
                        
                    }
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                    }
                    
                    //
                    // To update anything on the main thread, just jump back on like so.
                    DispatchQueue.main.async {
                        print("Am I back on the main thread: \(Thread.isMainThread)")
                        self.coordinatorDelegate?.emailSignUpViewModelDidCreateAccount(viewModel: self)
                    }
            }
        )
        
    }
}
