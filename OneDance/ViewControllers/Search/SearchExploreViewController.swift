//
//  SearchExploreViewController.swift
//  OneDance
//
//  Created by Burak Can on 3/24/18.
//  Copyright © 2018 Burak Can. All rights reserved.
//

import UIKit

class SearchContainerVC: UISearchContainerViewController {
    
    init() {
        //let src = SearchResultsController(data:data)
        let searcher = UISearchController(searchResultsController: nil)
        super.init(searchController: searcher)
        
        //searcher.searchResultsUpdater = src
        searcher.hidesNavigationBarDuringPresentation = false
        
        if #available(iOS 11.0, *) {
            //navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            self.navigationItem.titleView = searcher.searchBar
        }
        
        let b = searcher.searchBar
        b.autocapitalizationType = .none
        b.delegate = self
        b.showsCancelButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white // ugly otherwise
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchContainerVC : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
    }
}


class SearchExploreViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        searchController.searchBar.showsCancelButton = true
        
        self.searchController.delegate = self //UISearchControllerDelegate
        self.searchController.searchBar.delegate = self //UISearchBarDelegate
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
         */
        
        self.title = "Explore"

        self.configureNavigationBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureNavigationBar(){
        
        let newBackButton = UIBarButtonItem(image: UIImage(named:"magnifying-glass-white"), style: .plain, target: self, action: #selector(searchTapped(sender:)))
        self.navigationItem.rightBarButtonItem = newBackButton
        
    }
    
    @objc
    func searchTapped(sender: UIBarButtonItem){
        
        let vc = SearchContainerVC()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    

}


extension SearchExploreViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //
        
    }
}

extension SearchExploreViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        //filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension SearchExploreViewController : UISearchControllerDelegate {
    
    
}
