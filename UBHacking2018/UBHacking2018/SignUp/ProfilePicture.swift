//
//  ProfilePicture.swift
//  UBHacking2018
//
//  Created by Baily Troyer on 11/3/18.
//  Copyright © 2018 UBHacking. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfilePicture: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        profilePicture.addGestureRecognizer(tapGesture)
        profilePicture.isUserInteractionEnabled = true
        
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.layer.masksToBounds = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            //image tapped
            
            print("image tapped")
            
            let image = UIImagePickerController()
            image.delegate = self
            // can also select camera
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            //can change to true if needed
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
            //self.present(image, animated: true) {
            //after complete
            //print("image selected")
            // }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            profilePicture.image = image
            let userUid = Auth.auth().currentUser?.uid
            
            let profPicStorage = Storage.storage(url:"gs://ubhacking2018.appspot.com")
            let storageRef = profPicStorage.reference()
            
            
            // Create a reference to the file you want to upload
            //            let uploadPic = storageRef.child("PROFILE_PICTURES").child(userUid! + ".jpeg")
            let uploadPic = storageRef.child("PROFILE_PICTURES").child(userUid!)
            var data = NSData()
            data = image.jpegData(compressionQuality: 0.8)! as NSData
            // set upload path
            //let filePath = "\(Auth.auth().currentUser!.uid)/\("userPhoto")"
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            _ = uploadPic.putData(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print("error")
                    print(error.localizedDescription)
                    return
                }
            }
        } else {
            //ERROR
            print("ERROR")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
