//
//  ViewController.swift
//  Flour Power 2.0
//
//  Created by Kelly Robinson on 8/4/16.
//  Copyright © 2016 Kelly Robinson. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var sMR: UIButton!
    @IBOutlet weak var sFR: UIButton!
    
    @IBOutlet weak var category0: PrettyButton!
    @IBOutlet weak var category1: PrettyButton!
    @IBOutlet weak var category2: PrettyButton!
    @IBOutlet weak var category3: PrettyButton!
    @IBOutlet weak var category4: PrettyButton!
    @IBOutlet weak var category5: PrettyButton!
    
    @IBAction func searchMyRecipes(_ sender: AnyObject) {
        
    }
    @IBAction func searchForRecipes(_ sender: AnyObject) {
        
    }
    
    @IBAction func categoryButton(_ sender: UIButton) {
        
        let recipesVC = storyboard?.instantiateViewController(withIdentifier: "RecipesVC") as? RecipesCollectionVC
        
        
        recipesVC?.category = sender.titleLabel?.text
        recipesVC?.categoryID = sender.tag
        
        
        navigationController?.pushViewController(recipesVC!, animated: true)
        
    }
    
    @IBOutlet weak var staticImageView: UIImageView!
    
    @IBOutlet weak var smallLogo: UIButton!
    
    @IBAction func smallLogoButton(_ sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationController!.navigationBar.tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        var info = RequestInfo()
        
        info.endpoint = "/categories"
        info.method = .GET
        
        RailsRequest.session().requiredWithInfo(info) { (returnedInfo) -> () in
            
            if let categories = returnedInfo?["categories"] as? [[String:AnyObject]] {
                
                print(categories)
                
                self.category0.tag = categories[0]["id"] as? Int ?? 0
                self.category1.tag = categories[1]["id"] as? Int ?? 0
                self.category2.tag = categories[2]["id"] as? Int ?? 0
                self.category3.tag = categories[3]["id"] as? Int ?? 0
                self.category4.tag = categories[4]["id"] as? Int ?? 0
                self.category5.tag = categories[5]["id"] as? Int ?? 0
                
                self.category0.setTitle(categories[0]["name"] as? String ?? "", for: UIControlState())
                self.category1.setTitle(categories[1]["name"] as? String ?? "", for: UIControlState())
                self.category2.setTitle(categories[2]["name"] as? String ?? "", for: UIControlState())
                self.category3.setTitle(categories[3]["name"] as? String ?? "", for: UIControlState())
                self.category4.setTitle(categories[4]["name"] as? String ?? "", for: UIControlState())
                self.category5.setTitle(categories[5]["name"] as? String ?? "", for: UIControlState())
                
            }
            
        }
        
    }
    
}

