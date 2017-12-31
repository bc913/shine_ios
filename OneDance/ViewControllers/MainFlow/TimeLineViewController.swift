//
//  TimeLineViewController.swift
//  OneDance
//
//  Created by Burak Can on 12/26/17.
//  Copyright © 2017 Burak Can. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController {

    
    var viewModel : TimeLineViewModelType? {
        
        willSet{
            self.viewModel?.viewDelegate = nil
        }
        didSet{
            self.viewModel?.viewDelegate = self
            //self.refreshDisplay()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shine"
        self.configureNavigationBar()

        // Do any additional setup after loading the view.
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
        
        self.navigationController?.present(actionSheet, animated: true, completion: nil)
    }
    
    private func createOrganizationAction(){
        /*
        let vc = EditCreateOrganizationViewController(nibName: "EditCreateOrganizationViewController", bundle: nil)
        vc.viewModel = OrganizationViewModel(mode: .create)
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.present(navigationController, animated: true, completion: nil)
 */
        
        self.viewModel?.createOrganization()
    }
    
    private func createEventAction(){
        
        self.viewModel?.createEvent()
    }

}

extension TimeLineViewController : TimeLineViewModelViewDelegate {
    
}
