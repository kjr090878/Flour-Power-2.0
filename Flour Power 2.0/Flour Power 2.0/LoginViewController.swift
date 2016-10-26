//
//  LoginViewController.swift
//  Flour Power 2.0
//
//  Created by Kelly Robinson on 8/4/16.
//  Copyright © 2016 Kelly Robinson. All rights reserved.
//

import UIKit
import Foundation


class LoginViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var flourLargeLogoImage: UIImageView!
    
    @IBOutlet weak var bgImage: UIImageView!
    
 
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginOutlet: PrettyButton!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var loginRegisterOutlet: PrettyButton!
    
    @IBAction func loginRegisterAction(_ sender: AnyObject) {
        self.myActivityIndicator.startAnimating()
        
    }
    @IBAction func pressedLogin(_ sender: AnyObject) {
      
        self.myActivityIndicator.startAnimating()

        guard let password = passwordField?.text else { return }
        guard let email = emailField.text else { return }
        //if they aren't empty
        
        print("login pressed")
        
        RailsRequest.session().loginWithEmail(email, andPassword: password, completion: {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
            self.navigationController?.pushViewController(homeVC!, animated: true)
           self.myActivityIndicator.stopAnimating()
        })
        
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField?.delegate = self
        passwordField?.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        navigationController!.navigationBar.tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:
            NSNotification.Name.UIKeyboardWillShow, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        
       
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -210
        
    }
    
    func keyboardWillHide(_ sender: Notification) {
        
        self.view.frame.origin.y = 0
        
    }
    
    func textFieldShouldReturn(_ userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true
    }
    
}
