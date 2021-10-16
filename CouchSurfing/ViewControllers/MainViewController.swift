//
//  MainViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 17.10.21.
//

import UIKit

class MainViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchBar()
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.delegate = self
        searchController.searchBar.resignFirstResponder()
    }
    
    private func configureUI() {
        title = "Home"
        view.backgroundColor = .white
    }
}

// MARK: Handling interactions with search bar
extension MainViewController: UISearchBarDelegate {

}
