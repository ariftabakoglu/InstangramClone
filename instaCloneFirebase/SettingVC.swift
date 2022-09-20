//
//  SettingVC.swift
//  instaCloneFirebase
//
//  Created by Arif TABAKOĞLU on 19.09.2022.
//

import UIKit
import Firebase

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        
        do {
           try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print(error.localizedDescription)
        }
       
        
    }
    
}
