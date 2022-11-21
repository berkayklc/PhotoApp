//
//  UploadViewController.swift
//  PhotoApp
//
//  Created by Berkay KILIÇ on 16.11.2022.
//

import UIKit
import Parse

class UploadViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(keyboardRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        shareButton.isEnabled = false
        
    }
    

    @IBAction func shareButtonClicked(_ sender: Any) {
        shareButton.isEnabled = false
        let post = PFObject(className: "Post")
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        if let data = data {
            if PFUser.current() != nil {
                let parseImage = PFFileObject(name: "image.jpg", data: data)
                
                post["PostImage"] = parseImage
                post["Comment"] = commentText.text!
                post["PostUser"] = PFUser.current()!.username!
                
                post.saveInBackground {(success , error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error.!", message: error?.localizedDescription ?? "Error..!", preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                        alert.addAction(okButton)
                        self.present(alert, animated: true)
                    } else {
                        
                        self.commentText.text = ""
                        self.imageView.image = UIImage(named: "selectimage")
                        self.tabBarController?.selectedIndex = 0
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPost"), object: nil)
                    }
                    
                }
                
                
            }
        }
        
        
    }
    
    @objc func hideKeyboard () {
        view.endEditing(true)
    }
    @objc func selectImage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
       
        present(pickerController, animated: true , completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        
        self.dismiss(animated: true)
        shareButton.isEnabled = true
    }
    
}
