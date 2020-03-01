//
//  SearchViewController.swift
//  WiPick
//
//  Created by 김도현 on 15/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit



class SearchViewController: UIViewController,UISearchControllerDelegate {
    lazy var CustomSearchBar : UISearchController = {
       let SearchBar = UISearchController(searchResultsController: nil)
        SearchBar.delegate = self
        SearchBar.obscuresBackgroundDuringPresentation = false
        SearchBar.searchBar.setDefaultSearchBar()
        SearchBar.searchBar.showsCancelButton = false
        SearchBar.searchBar.setSearchBarLightImage(Image: "Search_Icon.png")
        
        self.definesPresentationContext = true
        return SearchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = CustomSearchBar
            
        }
        
    }
    
}


extension UISearchBar {
    func setDefaultSearchBar() {
        self.tintColor = UIColor.blue
        self.searchBarStyle = .minimal
        let searchBarTextField = self.value(forKey: "searchField") as! UITextField
        searchBarTextField.textColor = UIColor.black
        searchBarTextField.tintColor = UIColor.black
        searchBarTextField.backgroundColor = .clear
        searchBarTextField.placeholder = "게시글 검색"
    }
    func setSearchBarLightImage(Image : String){
        if let TextFiled = self.value(forKey: "searchField") as? UITextField {
            if let rightView = TextFiled.rightView as? UIImageView {
                rightView.image = UIImage(named: Image)
            }
        }
    }
    func setSearchBarLeftImage(Image : String) {
        if let TextFiled = self.value(forKey: "searchField") as? UITextField {
            if let leftView =  TextFiled.leftView as? UIImageView {
                leftView.image = UIImage(named: Image)
            }
        }
    }
}
