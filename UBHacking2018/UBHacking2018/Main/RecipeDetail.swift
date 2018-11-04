//
//  RecipeDetail.swift
//  UBHacking2018
//
//  Created by Baily Troyer on 11/3/18.
//  Copyright © 2018 UBHacking. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct ingredientObj {
    
    var id:String
    var ingredient: String
    var name: String
    var price: NSNumber
    var sku: String
}

class RecipeDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ingredientView: UITableView!
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var RecipeImage: UIImageView!
    @IBOutlet weak var urlView: UILabel!
    
    var total_price = Double()
    
    var ref = Database.database().reference()
    
    var ruid: String = ""
    var rurl: String = ""
    var rtitle: String = ""
    var rimage = UIImage()
    var rimage_url: String = ""
    var ringredients: [String] = []
    
    var ingredientList = [ingredientObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUp.layer.cornerRadius = 10
        popUp.layer.masksToBounds = true
        
        view.isOpaque = true
        view.backgroundColor = .clear
        
        ingredientView.delegate = self
        ingredientView.dataSource = self
        
        self.titleName.text = self.rtitle
        //self.ingredientList = self.ringredients
        self.RecipeImage.image = self.rimage
        self.urlView.text = self.rurl
        
        
        self.ingredientView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(ingredientList.count)")
        return ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientView.dequeueReusableCell(withIdentifier: "RecipeIngredient", for: indexPath) as! RecipeIngredientCell
        
        cell.name.text = self.ingredientList[indexPath.row].name
        cell.price.text = "\(self.ingredientList[indexPath.row].price)"
        
        cell.clipsToBounds = true
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 39.5;//Choose your custom row height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addToCart(_ sender: Any) {
        self.ref.child("selected_recipes").child(self.ruid).setValue([
            "url": self.rurl,
            "title": self.rtitle,
            "ingredients": self.ringredients,
            "price": self.total_price,
            "image_url": self.rimage_url
        ])
        self.dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        let url = URL(string: "https://us-central1-primary-server-168620.cloudfunctions.net/recipe-prices?recipeurl=\(self.rurl)")
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
                                    if let ingredients = myDictionary["result"] as? [[String : Any]] {
                                        
                                        var total_val: Double = 0
                                        
                                        for ingredient in ingredients {

                                            let _id = ingredient["_id"] as! String
                                            let _ingredient = ingredient["ingredient"] as! String
                                            let _name = ingredient["name"] as! String
                                            let _price = ingredient["price"] as! NSNumber
                                            let _sku = ingredient["sku"] as! String
                                            
                                            total_val += (Double(_price))
                                            
                                            //let rImage = UIImage(url: URL(string: recipe["image"] as! String))

                                            self.ingredientList.append(ingredientObj(id: _id, ingredient: _ingredient, name: _name, price: _price, sku: _sku))

                                            //print("recipeList: \(self.available_recipes)")

                                            //                                            print(recipe["_id"] as! String)
                                            //                                            print(recipe["title"] as! String)
                                        }
                                        
                                        self.total_price += total_val
                                        
                                        print("THIS RELOAD")
                                        DispatchQueue.main.async {
                                            UIViewController.removeSpinner(spinner: sv)
                                            self.ingredientView.reloadData()
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
        }
        
    }
    
}
