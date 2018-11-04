//
//  FirstLastName.swift
//  UBHacking2018
//
//  Created by Baily Troyer on 11/3/18.
//  Copyright © 2018 UBHacking. All rights reserved.
//

import Foundation
import UIKit

class FirstLastName: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.warningLabel.text = ""
        phoneNumber.keyboardType = UIKeyboardType.decimalPad
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EmailPassword {
            vc.firstName = self.firstName.text!
            vc.lastName = self.lastName.text!
            vc.phoneNumber = self.phoneNumber.text!
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if (firstName.text != "" && lastName.text != "" && phoneNumber.text != "") {
            self.performSegue(withIdentifier: "to_profile_create", sender: self)
        } else {
            warningLabel.text = "enter a first, last name and phone number"
            warningLabel.textColor = UIColor.red
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.firstName.becomeFirstResponder()
    }
}
