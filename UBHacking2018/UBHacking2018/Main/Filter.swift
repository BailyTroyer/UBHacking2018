//
//  Filter.swift
//  UBHacking2018
//
//  Created by Baily Troyer on 11/3/18.
//  Copyright © 2018 UBHacking. All rights reserved.
//

import Foundation
import UIKit

struct recipeType {
    var name: String
}

class Filter: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recipeTypeView: UITableView!
    var types = [recipeType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isOpaque = true
        view.backgroundColor = .clear
        
        //self.types = [recipeType(name: "indian"), recipeType(name: "french"), recipeType(name: "american")]
        
        let url = URL(string: "https://us-central1-primary-server-168620.cloudfunctions.net/recipe-categories")
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
                                    if let types = myDictionary["categories"] as? NSArray {
                                        
                                        for type in types {
                                            print("TYPE: \(type)")
                                            self.types.append(recipeType(name: type as! String))
                                        }
                                        print("THIS RELOAD")
                                        DispatchQueue.main.async {
                                            self.recipeTypeView.reloadData()
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
        }
        
        
        recipeTypeView.delegate = self
        recipeTypeView.dataSource = self
        
        self.recipeTypeView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(types.count)")
        return types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = recipeTypeView.dequeueReusableCell(withIdentifier: "recipeType", for: indexPath) as! RecipeTypeCell
        
        cell.typeName.text = self.types[indexPath.row].name
        
        cell.clipsToBounds = true
        
        return (cell)
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
    
    
}
