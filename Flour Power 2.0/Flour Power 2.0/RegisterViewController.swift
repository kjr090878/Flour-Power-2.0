//
//  RegisterViewController.swift
//  Flour Power 2.0
//
//  Created by Kelly Robinson on 8/4/16.
//  Copyright © 2016 Kelly Robinson. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var flowersRegisterImage: UIImageView!
    @IBOutlet weak var backgroundRegisterImage: UIImageView!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerOutlet: PrettyButton!
    @IBAction func pressedRegister(sender: AnyObject) {
        
        guard let password = registerPasswordTextField?.text else { return }
        guard let email = registerEmailTextField.text else { return }
        
        print("registered pressed")
        
        
        //send request to server to create registration
        
        RailsRequest.session().registerWithEmail(email, andPassword: password, completion: {
            
            let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeVC")
            self.navigationController?.pushViewController(homeVC!, animated: true)
            
            
        })
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
