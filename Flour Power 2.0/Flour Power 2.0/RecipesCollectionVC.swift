//
//  RecipesCollectionVC.swift
//  Flour Power 2.0
//
//  Created by Kelly Robinson on 8/4/16.
//  Copyright © 2016 Kelly Robinson. All rights reserved.
//

import UIKit

private let reuseIdentifier = "RecipesCell"

typealias Dictionary = [String : AnyObject]


class RecipesCollectionVC: UICollectionViewController {
    
    var recipes: [Recipe] = []
    var recipe = Recipe!(nil)
    
    var category: String?
    var categoryID: Int?
    
    
    @IBOutlet var recipeCollectionView: UICollectionView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        recipes = []
        
        var info = RequestInfo()
        
        info.endpoint = "/categories/\(categoryID ?? 0)/recipes"
        info.method = .GET
        
        RailsRequest.session().requiredWithInfo(info) { (returnedInfo) -> () in
            
            //            print(returnedInfo)
            if let recipeInfos = returnedInfo?["recipes"] as? [[String:AnyObject]] {
                
                for recipeInfo in recipeInfos {
                    
                    let recipe = Recipe(info: recipeInfo, category: self.category)
                    
                    self.recipes.append(recipe)
                    
                    
                }
                
            }
            self.collectionView?.reloadData()
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recipes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCell", for: indexPath) as! RecipeCell
        
        
        let recipe = recipes[(indexPath as NSIndexPath).item]
        
        cell.recipeInfo = recipe
        
        cell.recipeImageView.image = recipe.recipeSourceImage ?? recipe.getImage()
        
        cell.recipeImageView.contentMode = .scaleAspectFill
        
        cell.titleLabel.text = recipe.recipeTitle
        
        
        return cell
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let recipe = recipes[(indexPath as NSIndexPath).item]
        
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? RecipeDetailVC
        
        
        detailVC?.recipe = recipe
        
        
        navigationController?.pushViewController(detailVC!, animated: true)
        
        
        
    }
    
    
}


class Recipe: NSObject {
    
    var category: String?
    var recipeID: Int?
    var recipeTitle: String?
    var ingredients: [[String:AnyObject]] = []
    var directions: [String] = []
    var recipeSourceURL: String?
    var recipeSourceImageURL: String?
    var recipeSource: String?
    var recipeSourceImage: UIImage?
    
    init(info: Dictionary, category: String?) {
        
        print(info)
        
        self.category = category
        
        recipeID = info["id"] as? Int
        recipeTitle = info["name"] as? String
        
        recipeSourceURL = info["source_url"] as? String
        recipeSourceImageURL = info["source_image_url"] as? String
        recipeSource = info["source_name"] as? String
        
        ingredients = info["ingredients"] as? [[String:AnyObject]] ?? []
        
        directions = info["directions"] as? [String] ?? []
        
    }
    
    func getImage() -> UIImage? {
        
        if let imageURL = URL(string: recipeSourceImageURL ?? "") {
            
            if let imageData = try? Data(contentsOf: imageURL) {
                
                recipeSourceImage = UIImage(data: imageData)
                return UIImage(data: imageData)
                
            }
            
        }
        
        return nil
        
    }
    
    
}
