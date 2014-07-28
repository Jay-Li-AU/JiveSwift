//
//  JVWebViewController.swift
//
//
//  Created by Jay Li on 15/07/2014.
//
//

import Foundation
class JVWebViewController: UIViewController, UIWebViewDelegate{
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var contentTitleBar: UINavigationItem!
    
    var instance:Jive?
    var content:JiveContent?
    
    override func viewDidAppear(animated: Bool) {
        
        self.webView.delegate = self;
        
        
        contentTitleBar.title = self.content!.subject;
        var s: String = self.content!.content.text;
        
        self.webView.loadHTMLString(s, baseURL: nil)
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        if segue.identifier == "beginEditing" {
            
            
            var editingViewController:JVEditingViewController  = segue.destinationViewController as JVEditingViewController;
            
            editingViewController.instance = self.instance;
            editingViewController.content = self.content;
        }
        
    }
    
    
}