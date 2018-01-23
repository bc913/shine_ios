//
//  ProfileImageSelectionViewController.swift
//  OneDance
//
//  Created by Burak Can on 10/22/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit
import AWSS3

class ProfileImageSelectionViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    private var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var progressView: UIProgressView!
    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var progressBlock: AWSS3TransferUtilityProgressBlock?
    var continueWithHandler : ((AWSTask<AWSS3TransferUtilityUploadTask>) -> Any)?
    
    var photoManager = PhotoManager.instance()
    
    private func configureAWS(){
        self.progressView.progress = 0.0;
        //self.selectProfileImageLabel.text = "Ready"
        
        self.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                self.progressView.progress = Float(progress.fractionCompleted)
                //self.selectProfileImageLabel.text = "Uploading..."
            })
        }
        
        self.completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                    //self.selectProfileImageLabel.text = "Failed"
                }
                else if(self.progressView.progress != 1.0) {
                    //self.selectProfileImageLabel.text = "Failed"
                    NSLog("Error: Failed - Likely due to invalid region / filename")
                }
                else{
                    //self.selectProfileImageLabel.text = "Success"
                }
            })
        }
        
        self.continueWithHandler = {(task) -> AnyObject! in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    //self.selectProfileImageLabel.text = "Failed"
                }
                //
            }
            
            if let _ = task.result {
                DispatchQueue.main.async {
                    //self.selectProfileImageLabel.text = "Generating Upload File"
                }
                //
                print("Upload Starting!")
                // Do something with uploadTask.
            }
            
            return nil;
            
        }
        
    }
    
    fileprivate var isProfileImageSelected = false {
        didSet{
            self.doneButton.isHidden = !isProfileImageSelected
        }
    }
    
    var viewModel : ProfileImageSelectionViewModelType?
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if profileImageView != nil {
            viewModel?.submit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AWS
        self.configureAWS()
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        self.contentView.backgroundColor = UIColor(red: 0, green: 0.17, blue: 0.21, alpha: 1.0)
        
        self.configureProfileImage()
        self.configureImagePickerController()
        self.configureNavigationBar()
        
        // Configure button
        self.doneButton.configure(title: "Done", backgroundColor: UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0))
        self.doneButton.isHidden = !isProfileImageSelected
        
    }
    
    private func configureImagePickerController(){
        self.imagePickerController.delegate = self // UINavigationControllerDelegate
        self.imagePickerController.allowsEditing = false // TODO: You might change this
        
    }
    
    private func configureProfileImage(){
        
        let profileImage : UIImage = UIImage(named: "profile")!
        self.profileImageView.image = profileImage
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;
        self.profileImageView.contentMode = .scaleAspectFill // veya .center
        
        self.profileImageView.layer.borderWidth = 3.0
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    private func configureNavigationBar(){
        // Configure navigation bar
        // TODO: Update this code
        self.title = "Select image"
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName : UIColor.white]
        
        // Add skip
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipTapped))
        
        //
        // Kendisinden sonra stack a push edilen view controllerin navigation bar back buttonu nu kontrol eder
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    func skipTapped(){
        
        print("skip tapped")
        viewModel?.skip()
        
    }
    
    func profileImageTapped(tapGestureRecognizer: UIGestureRecognizer){
        if (tapGestureRecognizer.view as? UIImageView) != nil {
            showActionSheet()
        }
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.showPhotoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showCamera(){
        self.imagePickerController.sourceType = .camera
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    private func showPhotoLibrary(){
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    

}


extension ProfileImageSelectionViewController : UIImagePickerControllerDelegate {
    
    // TODO: Check for this error when the image is loaded.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = selectedImage
            self.photoManager.uploadProfilePhoto(with: UIImagePNGRepresentation(selectedImage)!,
                                                      progressBlock: self.progressBlock,
                                                      completionHandler: self.completionHandler,
                                                      continueWithHandler: self.continueWithHandler!)
            self.isProfileImageSelected = true
            print("image picked")
        } else {
            print("Exception")
        }
        
        //self.dismiss(animated: true, completion: nil)
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Not required but expected to implement
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
