//
//  SFPTableViewController.swift
//  Flour Power 2.0
//
//  Created by Kelly Robinson on 8/4/16.
//  Copyright © 2016 Kelly Robinson. All rights reserved.
//

import UIKit

public let ingredient = String()
public var type = String()


class SFPTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    
    var search_terms = String?()
    var category: String?
    var data = [String]()
    var recipes : [Recipe] = []
    var searchController: UISearchController!
    var searchResults = [String]()
    var searchActive : Bool = false
    var type = String?()
    
    
    @IBOutlet weak var itemBackButton: UIBarButtonItem!
    
    @IBAction func bButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var sLogo: UIButton!
    @IBOutlet weak var appSearchBar: UISearchBar!
    
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
        appSearchBar.resignFirstResponder()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return recipes.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        
        let recipe = recipes[(indexPath as NSIndexPath).row]
        
        print(recipe.recipeTitle)
        
        cell.recipeInfo = recipe
        
        cell.myLabel?.text = recipe.recipeTitle
        
        cell.MyImage?.image = recipe.recipeSourceImage ?? recipe.getImage()
        
        cell.MyImage?.contentMode = .scaleAspectFill
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            
            self.tableView.reloadData()
        }
        
        
        
        return cell
        
    }
    
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        searchActive = true
        
        
        
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        dismissKeyboard()
        appSearchBar.text = ""
        self.tableView.reloadData()
        
        //    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if(searchActive) {
        //            return recipes.count
        //        }
        //        return data.count
        //
        //    }
        
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            recipes = []
            
            let searchText = appSearchBar.text ?? ""
            
            var info = RequestInfo()
            
            info.endpoint = "/recipes/search?name=\(searchText)"
            
            info.method = .GET
            
            RailsRequest.session().requiredWithInfo(info) { (returnedInfo) -> () in
                
                //            print(returnedInfo)
                if let recipeInfos = returnedInfo?["recipes"] as? [[String:AnyObject]] {
                    
                    for recipeInfo in recipeInfos {
                        
                        let recipe = Recipe(info: recipeInfo, category: self.category)
                        
                        self.recipes.append(recipe)
                        
                        
                    }
                    
                }
                self.tableView.reloadData()
            }
            
            DispatchQueue.main.async {
                
                self.dismissKeyboard()
                
            }
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
            
            let recipe = recipes[(indexPath as NSIndexPath).row]
            
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? RecipeDetailVC
            
            
            detailVC?.recipe = recipe
            
            
            navigationController?.pushViewController(detailVC!, animated: true)
            
        }
        
    }
    
    
}
