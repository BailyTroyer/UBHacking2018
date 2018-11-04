//
//  RecipeDetail.swift
//  UBHacking2018
//
//  Created by Baily Troyer on 11/3/18.
//  Copyright © 2018 UBHacking. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ingredientView: UITableView!
    @IBOutlet weak var popUp: UIView!
    
    var ingredientList: [String] = ["chocolate", "flour", "butter", "eggs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUp.layer.cornerRadius = 10
        popUp.layer.masksToBounds = true
        
        view.isOpaque = true
        view.backgroundColor = .clear
        
        ingredientView.delegate = self
        ingredientView.dataSource = self
        self.ingredientView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(ingredientList.count)")
        return ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("test")
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! ViewFeedRequestCell
        let cell = ingredientView.dequeueReusableCell(withIdentifier: "RecipeIngredient", for: indexPath) as! RecipeIngredientCell
        
        cell.name.text = self.ingredientList[indexPath.row]
        
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
    
    
}
