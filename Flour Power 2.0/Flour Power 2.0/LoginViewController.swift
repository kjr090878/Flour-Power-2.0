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
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginOutlet: PrettyButton!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var loginRegisterOutlet: PrettyButton!
    
    @IBAction func loginRegisterAction(sender: AnyObject) {
        
   
        
        
        
    }
    @IBAction func pressedLogin(sender: AnyObject) {
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        guard let password = passwordField?.text else { return }
        guard let email = emailField.text else { return }
        //if they aren't empty
        
        print("login pressed")
        
        RailsRequest.session().loginWithEmail(email, andPassword: password, completion: {
            
            let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeVC")
            self.navigationController?.pushViewController(homeVC!, animated: true)
            
        })
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField?.delegate = self
        passwordField?.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:
            UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
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
