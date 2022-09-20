//
//  FeedCell.swift
//  instaCloneFirebase
//
//  Created by Arif TABAKOĞLU on 20.09.2022.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var documentIDLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
    
        let fireStoreDateBase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            
            fireStoreDateBase.collection("Post").document(documentIDLabel.text!).setData(likeStore, merge: true)
            
        }
        
       
        
        
    }
}
