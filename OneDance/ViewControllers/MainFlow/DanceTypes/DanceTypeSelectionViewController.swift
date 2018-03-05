//
//  DanceTypeSelectionViewController.swift
//  OneDance
//
//  Created by Burak Can on 3/4/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class DanceTypeSelectionViewController: UIViewController {
    
    
    @IBOutlet weak var danceTypesCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    fileprivate let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let minimumHorizontalSpacing: CGFloat = 4.0
    fileprivate let minimumLineSpacing : CGFloat = 4.0
    fileprivate let cellBorderWith : CGFloat = 4.0
    
    
    // 
    var viewModel : DanceTypesViewModelType?{
        willSet{
            viewModel?.viewDelegate = nil
        }
        
        didSet{
            viewModel?.viewDelegate = self
            //self.refreshDisplay()
        }
    }
    
    fileprivate func refreshDisplay(){
        self.danceTypesCollectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureNavigationBar()
        
        self.title = "Select Dances"

        // Do any additional setup after loading the view.
    }
    
    private func configureCollectionView(){
        self.flowLayout.scrollDirection = .vertical
        self.danceTypesCollectionView.delegate = self
        self.danceTypesCollectionView.dataSource = self
        self.danceTypesCollectionView.allowsMultipleSelection = true
        self.danceTypesCollectionView.register(BasicCollectionCell.self, forCellWithReuseIdentifier: BasicCollectionCell.identifier)
        
    }
    
    private func configureNavigationBar(){
        
        // Cancel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        // Create/Edit
        let createEditTitle : String = "Done"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: createEditTitle, style: .plain, target: self, action: #selector(doneEditing))
    }
    
    func doneEditing(){
        
        if self.viewModel?.selectedItems != nil || (self.viewModel?.selectedItems?.count)! > 0 {
            self.viewModel?.selectedItems?.removeAll()
        }
        
        self.danceTypesCollectionView.indexPathsForSelectedItems?.forEach({indexPath in
            self.viewModel?.selectedItems?.append((self.viewModel?.itemAtIndex(indexPath.row))!)
        })
        
        self.viewModel?.doneSelecting()
    }
    
    func cancel(){
        self.viewModel?.cancelSelection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DanceTypeSelectionViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.viewModel != nil {
            return self.viewModel!.numberOfItems
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicCollectionCell.identifier, for: indexPath) as! BasicCollectionCell
        
        let item = self.viewModel?.itemAtIndex(indexPath.row)
        cell.configure(text: item?.name ?? "")
        
        return cell
    }
}

extension DanceTypeSelectionViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //
    }
}

extension DanceTypeSelectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left + sectionInsets.right + collectionView.contentInset.left + collectionView.contentInset.right + 4
        let availableWidth = collectionView.frame.width - (paddingSpace + (itemsPerRow - 1) * self.minimumHorizontalSpacing + itemsPerRow * 2 * self.cellBorderWith)
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
}

extension DanceTypeSelectionViewController : DanceTypesViewModelViewDelegate {
    
    func itemsDidChange(viewModel: DanceTypesViewModelType) {
        self.refreshDisplay()
    }
    
    func notifyUser(_ viewModel: DanceTypesViewModelType, _ title: String, _ message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        return
    }
}
