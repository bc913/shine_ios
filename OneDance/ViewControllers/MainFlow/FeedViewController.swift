//
//  FeedViewController.swift
//  OneDance
//
//  Created by Burak Can on 11/13/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavigationBar()
        
        self.title = "Shine"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func configureNavigationBar(){
        
        // Add skip
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    func addTapped(){
        self.showActionSheet()
    }
    
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Create Organization", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.createOrganizationAction()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Create Event", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.createEventAction()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func createOrganizationAction(){
        
        let vc = EditCreateOrganizationViewController(nibName: "EditCreateOrganizationViewController", bundle: nil)
        vc.viewModel = OrganizationViewModel(mode: .create)
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.present(navigationController, animated: true, completion: nil)
    }

    private func createEventAction(){
        
        let vc = EditCreateEventViewController(nibName: "EditCreateEventViewController", bundle: nil)
        vc.viewModel = EventViewModel(mode: .create)
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.present(navigationController, animated: true, completion: nil)
    }
    

}
