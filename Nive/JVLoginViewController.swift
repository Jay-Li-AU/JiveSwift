//
//  JVLoginViewController.swift
//  Nive
//
//  Created by Jay Li on 30/06/2014.
//  Copyright (c) 2014 Jay Li. All rights reserved.
//

import UIKit
class JVLoginViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var userName:UITextField! ;
    @IBOutlet weak var password:UITextField! ;
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView! ;
    
    var me:JivePerson? ;
    
    override func viewDidAppear(animated: Bool) {
        self.password.text = nil
        self.userName.becomeFirstResponder()
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        (segue.destinationViewController as JVMasterViewController).me = self.me
    }
    
    
    func handleLogin(person: JivePerson ) {
        self.me = person;
        self.performSegueWithIdentifier("Login", sender:self);
        self.resetLoginView();
    }
    
    func resetLoginView() {
        self.activityIndicator.stopAnimating();
        self.userName.enabled = true;
        self.password.enabled = true;
        self.password.text = nil;
    }
    
    
    func textFieldShouldReturn(textField:UITextField )->Bool {
        if textField == self.userName {
            self.password.becomeFirstResponder()
        } else if self.userName.text.utf16Count == 0 {
            self.userName.becomeFirstResponder();
        } else if (self.password.text.utf16Count > 0) {
            self.activityIndicator.startAnimating();
            self.password.resignFirstResponder();
            self.userName.enabled = false;
            self.password.enabled = false;
            
            
            JVJiveFactory.loginWithName(self.userName.text, password: self.password.text, complete: {
                (person:JivePerson?)->Void in
                self.handleLogin(person!)
                
                }, error: {
                    (error:NSError!)->Void in
                    self.resetLoginView()
                    self.password.becomeFirstResponder()
                })
            
        }
        
        return false;
    }
    
}