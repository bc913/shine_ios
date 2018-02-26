//
//  PostViewModel.swift
//  OneDance
//
//  Created by Burak Can on 2/24/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import Foundation

//==================
// New Post
//==================

protocol NewPostType {
    var text : String { get set }
    var media : UploadedMediaType? { get set }
    var location : LocationLiteType? { get set }
}

struct NewPost : NewPostType {
    
    var text : String = ""
    
    var media : UploadedMediaType?
    var location : LocationLiteType?
    
}

extension NewPost : JSONDecodable {
    
    var jsonData : [String:Any] {
        
        
        var json = [String:Any]()
        json["text"] = self.text
        
        if self.media != nil {
            let mediaJson = self.media as? JSONDecodable
            json["media"] = mediaJson?.jsonData
        }
        
        if self.location != nil {
            let locJson = self.location as? JSONDecodable
            json["location"] = locJson?.jsonData
        }
        
        return json
    }
    
}

//==================
// Post View model
//==================

protocol PostViewModelViewDelegate : class {
    
}

protocol PostViewModelCoordinatorDelegate : class {
    
}

typealias PostVMCoordinatorDelegate = PostViewModelCoordinatorDelegate & ChildViewModelCoordinatorDelegate


protocol PostViewModelType : class {

}

class PostViewModel {
    
    // Delegates
    var coordinatorDelegate : PostVMCoordinatorDelegate?
    var viewDelegate : PostViewModelViewDelegate?
    
    var id : String = ""
    var mode : ShineMode = .create
    var model : NewPostType?
    var errorMessage : String = ""
    
    // Photmanager
    var photoManager = PhotoManager.instance()

    
    init(mode: ShineMode = .create, id: String = "") {
        self.mode = mode
        self.id = ""
        
        if self.mode == .create {
            self.model = NewPost()
        } else {
            
            let modelCompletionHandler = {(error: NSError?, model: NewPostType?) in
                
                DispatchQueue.main.async {
                    guard let error = error else {
                        
                        self.model = model
                        return
                    }
                    
                    // error
                    self.model = nil
                    self.errorMessage = error.localizedDescription
                    
                }
                
            }
            
            // Make the server call to edit
        }
    }
    
    // Properties
    var text : String = ""
    var location : LocationItem?
    var imageData : Data? // for create operation
    
    // Handlers
    
    lazy var modelCompletionHandler : (NSError?, PostDetailType?) -> () = { [unowned self] (error, model)  in
        
        DispatchQueue.main.async {
            guard let error = error else {
                
                self.coordinatorDelegate?.viewModelDidFinishOperation(mode: self.mode)
                return
            }
            
            self.errorMessage = error.localizedDescription
        }
        
    }
    
    lazy var modelCompletionHandlerForImageUpload : (NSError?, UploadedMediaType?) -> () = { [unowned self] (error, media) in
        
        DispatchQueue.main.async {
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            } else {
                print("UploadCompleted:  \(media!.name)")
                self.model?.media = media
                ShineNetworkService.API.Feed.createPost(model: self.model as! NewPost, mainThreadCompletionHandler: self.modelCompletionHandler)
            }
            
        }
        
    }
    
    
    
    // Methods
    private func updateModel(){
        
        self.model?.text = self.text
        self.model?.location = self.location?.mapToLiteModel()
        // Assign media properties in PhotosManager
        
        
    }
    
    func create(){
        
        self.updateModel()
        
        if self.imageData != nil {
            self.photoManager.uploadPostImage(with: imageData!, progressBlock: nil, completionHandler: self.modelCompletionHandlerForImageUpload)
        } else {
            ShineNetworkService.API.Feed.createPost(model: self.model as! NewPost, mainThreadCompletionHandler: self.modelCompletionHandler)
        }
        
    }
    
    func cancel(){
        self.coordinatorDelegate?.viewModelDidFinishOperation(mode: self.mode)
    }
    
}
