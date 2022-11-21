//
//  ViewController.swift
//  PhotoApp
//
//  Created by Berkay KILIÇ on 16.11.2022.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
    }
    
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { (user , error) in
                if error != nil {
                    self.errorMessage(title: "Error..!", message: error?.localizedDescription ?? "Error..!")
                } else {
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
            
        }else {
            errorMessage(title: "Error..!", message: "Please enter your username and password..")
        }
        
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" {
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordText.text!
            user.signUpInBackground {(success, error) in
                if error != nil {
                    self.errorMessage(title: "Error.!", message: error?.localizedDescription ?? "Hata")
                }else {
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
                
            }
            
        }else {
            
            errorMessage(title: "Error..!", message: "You should enter username and password")
            
        }
        
        
    }
    

    func errorMessage(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

}

