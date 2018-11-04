//
//  EmailPassword.swift
//  UBHacking2018
//
//  Created by Baily Troyer on 11/3/18.
//  Copyright © 2018 UBHacking. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class EmailPassword: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    
    let db = Firestore.firestore()
    
    var firstName = String()
    var lastName = String()
    var phoneNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.text = ""
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        //let timestamp: Timestamp = DocumentSnapshot.get("created_at") as! Timestamp
        //let date: Date = timestamp.dateValue()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.email.becomeFirstResponder()
    }
    
    @IBAction func next(_ sender: Any) {
        print("testing create profile firestore")
        
        let charset = CharacterSet(charactersIn: "!#$%^&*()_+=-`~:,?")
        if email.text?.rangeOfCharacter(from: charset) != nil {
            warningLabel.text = "invalid characters in email"
            warningLabel.textColor = UIColor.red
        } else if email.text == "" {
            warningLabel.text = "please enter a valid email"
            warningLabel.textColor = UIColor.red
        } else if password.text == "" {
            warningLabel.text = "please enter a stronger password"
            warningLabel.textColor = UIColor.red
        } else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
                if error != nil {
                    print("ERROR SIGNING UP USER: \(String(describing: error?.localizedDescription))")
                    
                    self.warningLabel.textColor = UIColor.red
                    self.warningLabel.text = error?.localizedDescription
                } else {
                    let dname = "\(self.firstName) \(self.lastName)"
                    print("changing display name to : \(dname)")
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = dname
                    changeRequest?.commitChanges { (error) in
                        if error != nil {
                            print(error?.localizedDescription as Any)
                        } else {
                            
                            // SEND DATA TO MODEL
                            
                            Auth.auth().currentUser?.sendEmailVerification { (error) in
                                
                                if error != nil {
                                    print(error)
                                } else {
                                    print("sent email verif")
                                    
                                    
                                    if let uid = (Auth.auth().currentUser?.uid) {
                                        
                                        // var ref: DocumentReference? = nil
                                        
                                        self.db.collection("users").document(uid).setData([
                                            uid: [
                                                "first_name": self.firstName,
                                                "last_name": self.lastName,
                                                "phone_number": Int(self.phoneNumber)!
                                            ]
                                        ]) { err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            } else {
                                                print("Document successfully written!")
                                            }
                                        }
                                    } else {
                                        print("THERE IS AN ERROR WITH SIGN UP")
                                    }
                                    
                                    
                                    
                                }
                            }
                            
                        }
                    }
                    self.performSegue(withIdentifier: "to_profile_pic", sender: self)
                }
                
            }
        }
    }
    
    
}
