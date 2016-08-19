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
    
    @IBOutlet weak var flourLargeLogoImage: UIImageView!
    
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var segueToHomeVCActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginOutlet: PrettyButton!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var loginRegisterOutlet: PrettyButton!
    
    @IBAction func loginRegisterAction(sender: AnyObject) {
        
    }
    @IBAction func pressedLogin(sender: AnyObject) {
      
        
        guard let password = passwordField?.text else { return }
        guard let email = emailField.text else { return }
        //if they aren't empty
        
        print("login pressed")
        
        RailsRequest.session().loginWithEmail(email, andPassword: password, completion: {
            
            let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeVC")
            self.navigationController?.pushViewController(homeVC!, animated: true)
            
            self.segueToHomeVCActivityIndicator.startAnimating()
            self.segueToHomeVCActivityIndicator.hidden = true
            self.segueToHomeVCActivityIndicator.stopAnimating()
           
            
        })
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField?.delegate = self
        passwordField?.delegate = self
        self.navigationController?.navigationBarHidden = true
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:
            UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
   
        
    }
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        self.view.frame.origin.y = -210
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        self.view.frame.origin.y = 0
        
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true
    }
    
}
