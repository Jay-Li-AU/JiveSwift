//
//  JVCommunityViewController.swift
//  Nive
//
//  Created by Jay Li on 30/06/2014.
//  Copyright (c) 2014 Jay Li. All rights reserved.
//

import UIKit
class JVCommunityViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var communityURL: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func advanceToLogin(factory:JVJiveFactory ) {
        self.activityIndicator.stopAnimating();
        JVJiveFactory.setInstance(factory)
        self.performSegueWithIdentifier("Community", sender: self)
        
    }
    
    override func viewDidLoad() {
        var instanceString: String  = "http://svpos0000064np.nbndc.local/";
        self.communityURL.text = instanceString
    }
    func checkForRedirect(version:JivePlatformVersion,
        fromURL targetURL:NSURL,
        factory initialFactory:JVJiveFactory ) {
            // Not all instances report their url in the version.
            if !version.instanceURL || version.instanceURL == targetURL {
                self.advanceToLogin(initialFactory)
                
            } else {
                // Attempt to redirect to the server's instance url.
                var factory:JVJiveFactory?  = nil;
                
                factory = JVJiveFactory(instanceURL: version.instanceURL, completeBlock: {
                    (redirectVersion:JivePlatformVersion!) -> Void in
                    self.communityURL.text = redirectVersion.instanceURL.absoluteString;
                    self.advanceToLogin(factory!)
                    }, errorBlock: {
                        (error:NSError!) -> Void in
                        self.advanceToLogin(initialFactory)
                    })
                
            }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.communityURL.enabled = true;
        self.communityURL.becomeFirstResponder();
        super.viewDidAppear(animated);
    }
    
    
    
    
    
    func textFieldShouldReturn (textField:UITextField )-> Bool {
        // Assume the default instance.
        var instanceString: String  = "https://community.jivesoftware.com/";

        // Check to see if the user entered a different url.
        if (self.communityURL.text.utf16Count > 0) {
            instanceString = self.communityURL.text;
            if !instanceString.hasPrefix("http") {
                instanceString = "http://"+instanceString;
                // But what if it should be https:// ?
            }
            
            // The SDK assumes the URL has a / at the end. So make sure it does.
            if !instanceString.hasSuffix("/") {
                instanceString = instanceString+"/"
            }
        }
        
        var instanceURL: NSURL  = NSURL(string: instanceString)
        var factory:JVJiveFactory?  = nil;
        self.activityIndicator.startAnimating()
        self.communityURL.resignFirstResponder()
        
        self.communityURL.enabled = false;
        // Is it a valid instance?
        
        
        factory = JVJiveFactory(instanceURL: instanceURL, completeBlock: {
            (version:JivePlatformVersion!)-> Void in
            self.checkForRedirect(version, fromURL: instanceURL, factory: factory!)
            }, errorBlock: {
                (error:NSError!)->Void in
                self.activityIndicator.stopAnimating()
                self.communityURL.enabled = true
                self.communityURL.becomeFirstResponder()
            })
        

        
        return false;
    }
    
    
    
}