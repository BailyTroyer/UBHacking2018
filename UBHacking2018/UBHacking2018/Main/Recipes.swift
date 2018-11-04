//
//  Recipes.swift
//  UBHacking2018
//
//  Created by Baily Troyer on 11/3/18.
//  Copyright © 2018 UBHacking. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct availRecipe {
    var uid: String
    var title: String
    var image: UIImage
    var ingredients: [String]
    var url: String
    var image_url: String
}

class Recipes: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recipeList: UITableView!
    
    var available_recipes = [availRecipe]()
    
    var clicked_recipe = availRecipe(uid: "", title: "", image: #imageLiteral(resourceName: "baseline_close_black_36pt"), ingredients: [""], url: "", image_url: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeList.delegate = self
        recipeList.dataSource = self
        
        print("reloading data")
        self.recipeList.reloadData()
    }
    
    @IBAction func filter(_ sender: Any) {
        self.performSegue(withIdentifier: "to_filter", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return available_recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = recipeList.dequeueReusableCell(withIdentifier: "Recipe", for: indexPath) as! RecipeCell
        
        //cell.recipeName.text = self.available_recipes[indexPath.row].name
        //cell.recipeImage.image = self.available_recipes[indexPath.row].image
        
        print("recipe Name: \(self.available_recipes[indexPath.row].title)")
        
        cell.recipeName.text = self.available_recipes[indexPath.row].title
        cell.recipeImage.image = self.available_recipes[indexPath.row].image
        
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row <= self.available_recipes.count-1 {
            
            //            self.selectedSkills.append(self.skills_structs[indexPath.row])
            //
            //            self.current_selected_desc = self.skills_structs[indexPath.row].desc as! String
            //            self.current_selected_name = self.skills_structs[indexPath.row].name as! String
            
            self.performSegue(withIdentifier: "show_detail", sender: self)
            
            self.recipeList.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        let url = URL(string: "https://us-central1-primary-server-168620.cloudfunctions.net/recipes-by-category?category=Mexican")
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        //print(stringData) //JSONSerialization
                        //---
                        var dictonary:NSDictionary?
                        if let data = stringData.data(using: String.Encoding.utf8) {
                            
                            do {
                                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as! NSDictionary
                                
                                if let myDictionary = dictonary as? [String : Any]
                                {
                                    print("DATA: \(myDictionary)")
                                    if let recipes = myDictionary["result"] as? [[String : Any]] {
                                        for recipe in recipes {
                                            
                                            let rUid = recipe["_id"] as! String
                                            let rTitle = recipe["title"] as! String
                                            let rUrl = recipe["url"] as! String
                                            let rIngredients = recipe["ingredients"] as! NSArray
                                            let rImage = UIImage(url: URL(string: recipe["image"] as! String))
                                            let rImageUrl = recipe["image"] as! String
                                            
                                            self.available_recipes.append(availRecipe(uid: rUid, title: rTitle, image: rImage!, ingredients: rIngredients as! [String], url: rUrl, image_url: rImageUrl))
                                            
                                            //print("recipeList: \(self.available_recipes)")
                                            
                                            //                                            print(recipe["_id"] as! String)
                                            //                                            print(recipe["title"] as! String)
                                        }
                                        print("THIS RELOAD")
                                        DispatchQueue.main.async {
                                            UIViewController.removeSpinner(spinner: sv)
                                            self.recipeList.reloadData()
                                        }
                                        //self.recipeList.reloadData()
                                    }
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        }
                        //---
                    }
                }
            })
            task.resume()
            print("reloading data")
            self.recipeList.reloadData()
        }
        print("reloading data again")
        self.recipeList.reloadData()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RecipeDetail {
            vc.rurl = self.clicked_recipe.url
            vc.rtitle = self.clicked_recipe.title
            vc.rimage = self.clicked_recipe.image
            vc.ringredients = self.clicked_recipe.ingredients
            vc.ruid = self.clicked_recipe.uid
            vc.rimage_url = self.clicked_recipe.image_url
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("selected: \(self.available_recipes[indexPath.row])")
        
        self.clicked_recipe = self.available_recipes[indexPath.row] as! availRecipe
        
        self.performSegue(withIdentifier: "show_detail", sender: self)
    }



}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
