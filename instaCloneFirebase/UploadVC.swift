//
//  UploadVC.swift
//  instaCloneFirebase
//
//  Created by Arif TABAKOĞLU on 19.09.2022.
//

import UIKit
import PhotosUI
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

    @IBOutlet weak var uploadButtonOutlet: UIButton!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        
        let alertController = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil)
        
        alertController.addAction(okButton)
        
        self.present(alertController, animated: true)
        
    }
    
    @objc func chooseImage(){
        
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
    
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
        
        
    }
   
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      
        dismiss(animated: true,completion: nil)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let myimage = image as? UIImage{
                    DispatchQueue.main.async {
                        self.imageView.image = myimage
                    }
                }else{
                    print(error?.localizedDescription ?? "Error")
                }
            }
            
        }
    }
    

    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.25){
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: "\(error?.localizedDescription ?? "Fail")")
                }else{
                    
                    imageReference.downloadURL { url, error in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            if let imageUrl = imageUrl {

                                
                                
                                // DataBase
                                
                                let fireStoreDatabase = Firestore.firestore()
                                var fireStoreRefence : DocumentReference? = nil
                                
                                let fireStorePost = ["imageUrl" : imageUrl, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0]
                                
                            
                                
                                fireStoreRefence = fireStoreDatabase.collection("Post").addDocument(data: fireStorePost ,completion: { error in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
                                    }else{
                                        
                                        self.imageView.image = UIImage(named: "select.jpg")
                                        self.commentText.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                        
                                    }
                                })
                                
                            }
                        }
                    }
                    
                }
            }
            
        }
            
        
    }
    
}
