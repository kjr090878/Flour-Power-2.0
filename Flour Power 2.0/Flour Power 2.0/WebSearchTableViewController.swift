//
//  WebSearchTableViewController.swift
//  Flour Power 2.0
//
//  Created by Kelly Robinson on 8/4/16.
//  Copyright © 2016 Kelly Robinson. All rights reserved.
//

import UIKit

class WebSearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var search_terms = String?()
    var category: String?
    var data : [String] = []
    var recipes: [Recipe] = []
    var searchController: UISearchController!
    var searchResults = [String]()
    var searchActive : Bool = false
    var type = String?()
    var categoryID: Int?
    
    
    
    @IBAction func backButtonItem(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var webSearchBar: UISearchBar!
    @IBOutlet weak var webSearchTV: UITableView!
    
    @IBOutlet weak var bbItem: UIBarButtonItem!
    @IBOutlet weak var imageLogo: UIButton!
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
    
    func dismissKeyboard() {
        
        webSearchBar.resignFirstResponder()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WebCell
        
        let recipe = recipes[(indexPath as NSIndexPath).row]
        
        print(recipe.recipeTitle)
        
        cell.recipeInfo = recipe
        
        cell.webTitleLabel?.text = recipe.recipeTitle
        
        cell.webView?.image = recipe.recipeSourceImage ?? recipe.getImage()
        
        cell.webView?.contentMode = .scaleAspectFill
        
        
        return cell
        
    }
    
    
    
    
    func updateSearchResults(for searchController: UISearchController)
    {
        searchActive = true
        webSearchBar.text = ""
        
        self.webSearchTV.reloadData()
        
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        dismissKeyboard()
        webSearchBar.text = ""
        self.tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        recipes = []
        
        let searchText = webSearchBar.text ?? ""
        
        var info = RequestInfo()
        info.endpoint = "/api/recipes/search?query=\(searchText)"
        info.method = .GET
        
        RailsRequest.session().requiredWithInfo(info) { (returnedInfo) -> () in
            
            if let recipeInfos = returnedInfo?["recipes"] as? [[String:AnyObject]] {
                
                for recipeInfo in recipeInfos {
                    
                    let recipe = Recipe(info: recipeInfo, category: self.category)
                    
                    self.recipes.append(recipe)
                    
                }
            }
            
            self.webSearchTV.reloadData()
            
        }
        
        DispatchQueue.main.async {
            self.dismissKeyboard()
            
        }
        
        
}
}
