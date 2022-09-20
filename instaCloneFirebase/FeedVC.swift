//
//  FeedVC.swift
//  instaCloneFirebase
//
//  Created by Arif TABAKOĞLU on 19.09.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray  = [Int]()
    var userImageArray = [String]()
    var documentIDArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.borderColor = UIColor.orange.cgColor
        tableView.layer.borderWidth = 0.5
        
        getDataFromFireStore()
        
    }
    
    func getDataFromFireStore(){
        
        let fireStoreDataBase = Firestore.firestore()
        fireStoreDataBase.collection("Post").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    self.userImageArray.removeAll()
                    self.userCommentArray.removeAll()
                    self.likeArray.removeAll()
                    self.userEmailArray.removeAll()
                    self.documentIDArray.removeAll()
                    
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        
                        if let imageURL = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageURL)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
}

extension FeedVC : UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: userImageArray[indexPath.row]))
        cell.documentIDLabel.text = documentIDArray[indexPath.row]
        
        return cell
    }
    
}
