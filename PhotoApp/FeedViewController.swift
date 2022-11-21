//
//  FeedViewController.swift
//  PhotoApp
//
//  Created by Berkay KILIÇ on 16.11.2022.
//

import UIKit
import Parse

class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var postArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newPost"), object: nil)
    }
    
    @objc func getData () {
        
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground{ (objects, error) in
            if error != nil {
                self.errorMessage(title: "Error..!", message: error?.localizedDescription ?? "Error..!")
            }else {
                if objects != nil {
                    if objects!.count > 0 {
                        
                        self.postArray.removeAll(keepingCapacity: false)
                        for object in objects! {
                            if let userName = object.object(forKey: "PostUser") as? String {
                                if let userComment = object.object(forKey: "Comment") as? String {
                                    if let userImage = object.object(forKey: "PostImage") as? PFFileObject {
                                        
                                        let post = Post(userName: userName, userComment: userComment, userImage: userImage)
                                        self.postArray.append(post)
                                        
                                    }
                                }
                            }
                            
                        }
                        self.tableView.reloadData()
                        
                    }
                }
                
            }
            
        }
        
    }
    func errorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.usernameLabel.text = postArray[indexPath.row].userName
        cell.userCommentLabel.text = postArray[indexPath.row].userComment
        
        postArray[indexPath.row].userImage.getDataInBackground {(data, error) in
            if error == nil {
                if let data = data {
                    cell.postImage.image = UIImage(data: data)
                }
            }
            
        }
        
        return cell
    }

    

}
