//
//  ViewController.swift
//  instaCloneFirebase
//
//  Created by Arif TABAKOĞLU on 18.09.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfiedl: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        

    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailTextfield.text != "" && passwordTextfiedl.text != "" {
            
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfiedl.text!) { authData, error in
        
            if error != nil {
                
             self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                
            }else{
                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                
            }
            
        }
            
        }else{
            
            self.makeAlert(titleInput: "Error!", messageInput: "Username/Password?")

        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailTextfield.text != "" && passwordTextfiedl.text != "" {
            
            Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfiedl.text!) { autData, error in
                
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
            
            
            
            
            
        }else{
            
            makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
            
        }
        
    
    }
    func makeAlert(titleInput:String,messageInput:String){
        
        let alert = UIAlertController(title: titleInput , message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true)
        
    }
}

