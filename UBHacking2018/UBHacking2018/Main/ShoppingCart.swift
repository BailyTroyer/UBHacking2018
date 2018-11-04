//
//  ShoppingCart.swift
//  UBHacking2018
//
//  Created by Baily Troyer on 11/4/18.
//  Copyright © 2018 UBHacking. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ShoppingCart: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var total_price = Double()
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var recipeList: UITableView!
    var recipes = [availRecipe]()
    
    var ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeList.delegate = self
        recipeList.dataSource = self
        
        self.ref.child("selected_recipes").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            for recipe_uid in value! {
                //print("rec UID: \(recipe_uid)")
                let inner = recipe_uid.value as! NSDictionary
                let ringreds = inner["ingredients"] as! [String]
                let rtitl = inner["title"] as! String
                let rurl = inner["url"] as! String
                let rprice = inner["price"] as! NSNumber
                let rImageUrl = inner["image_url"] as! String
                
                self.total_price += Double(truncating: rprice)
                
                print("url: \(rurl)")
                self.recipes.append(availRecipe(uid: recipe_uid.key as! String, title: rtitl, image: UIImage(url: URL(string: rImageUrl))!, ingredients: ringreds, url: rurl, image_url: rImageUrl ))
                
                self.recipeList.reloadData()
            }
            
            self.totalPrice.text = "\(self.total_price.string(maximumFractionDigits: 2))"
            self.recipeList.reloadData()
        })
        
        self.recipeList.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = recipeList.dequeueReusableCell(withIdentifier: "Recipe", for: indexPath) as! RecipeCell
        
        //cell.recipeName.text = self.available_recipes[indexPath.row].name
        //cell.recipeImage.image = self.available_recipes[indexPath.row].image
        
        print("recipe Name: \(self.recipes[indexPath.row].title)")
        
        cell.recipeName.text = self.recipes[indexPath.row].title
        cell.recipeImage.image = self.recipes[indexPath.row].image
        
        cell.clipsToBounds = true
        
        return cell
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//    }

}

extension Double {
    func string(maximumFractionDigits: Int = 2) -> String {
        let s = String(format: "%.\(maximumFractionDigits)f", self)
        var offset = -maximumFractionDigits - 1
        for i in stride(from: 0, to: -maximumFractionDigits, by: -1) {
            if s[s.index(s.endIndex, offsetBy: i - 1)] != "0" {
                offset = i
                break
            }
        }
        return String(s[..<s.index(s.endIndex, offsetBy: offset)])
    }
}
