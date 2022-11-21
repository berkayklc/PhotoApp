//
//  SettingsViewController.swift
//  PhotoApp
//
//  Created by Berkay KILIÇ on 16.11.2022.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        
        PFUser.logOutInBackground {(error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error..!", message: error?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            } else {
                self.performSegue(withIdentifier: "toViewController", sender: nil)
                
            }
            
        }
        
    }
    
 

}
