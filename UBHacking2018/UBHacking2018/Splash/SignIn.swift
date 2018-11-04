//
//  SignIn.swift
//  UBHacking2018
//
//  Created by Baily Troyer on 11/3/18.
//  Copyright © 2018 UBHacking. All rights reserved.
//

import Foundation

import UIKit
import Firebase
import FirebaseAuth

class SignIn: UIViewController {
    
//    @IBOutlet weak var warningLabel: UILabel!
//    @IBOutlet weak var loginButton: UIButton!
//    @IBOutlet weak var emailAddress: UITextField!
//    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.text = ""
        setupKeyboardDismissRecognizer()
        loginButton.bindToKeyboard()
        warningLabel.bindToKeyboard()
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        loginButton.bindToKeyboard()
    //        buttonsView.bindToKeyboard()
    //        self.emailAddress.becomeFirstResponder()
    //    }
    
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func login(_ sender: Any) {
        self.performSegue(withIdentifier: "to_main_home", sender: self)
        
        if emailAddress.text != "" && password.text != "" {
            Auth.auth().signIn(withEmail: emailAddress.text!, password: password.text!) { (user, error) in
                if error != nil {
                    //error
                    self.warningLabel.text = error?.localizedDescription
                    print("error: \(String(describing: error))")
                } else {
                    print("user: \(String(describing: user))")
                    self.performSegue(withIdentifier: "to_main_home", sender: self)
                }
            }
        } else {
            self.warningLabel.text = "enter an email and password"
        }
    }
    
    
}
extension UIView {
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let begginingFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - begginingFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
    
}
