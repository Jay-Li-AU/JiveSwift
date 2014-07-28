//
//  JVEditingViewController.swift
//  Nive
//
//  Created by Jay Li on 30/06/2014.
//  Copyright (c) 2014 Jay Li. All rights reserved.
//

import UIKit
class JVEditingViewController:UIViewController{
    
    @IBOutlet weak var titleField:UITextField! ;
    @IBOutlet var bodyWebField: UIWebView!

    @IBOutlet weak var activityIndicator:UIActivityIndicatorView! ;
    @IBOutlet weak var saveButton:UIBarButtonItem! ;
    
    var changed:Bool = false
    
    var instance:Jive?
    var content:JiveContent? {
    didSet {
        if content != oldValue {
            self.changed = true
        }else{
            self.changed = false
        }
    }
    }
    
    
    var refreshLockTimer:NSTimer?;
    
    
//    func loadEditContent(content:JiveContent){
//        
//            if self.changed {
//                
//                self.title = content.subject;
//                // self.titleField.text = content!.subject;
//                if self.instance?.platformVersion?.supportsContentEditingAPI {
//                    if content.type == JiveDocumentType {
//                        self.instance?.lockContentForEditing(content, withOptions: nil, onComplete: {
//                            (lockedContent:JiveContent!) -> Void in
//                            if lockedContent.content.editableValue{
//                                self.showEditableText(lockedContent)
//                            }
//                            else{
//                                self.getEditableVersion()
//                            }
//                            }, onError: {
//                                (error:NSError!) ->Void in
//                                NSLog("initial lockContentForEditing failed %@", error);
//                                self.activityIndicator.stopAnimating();
//                            })
//                    } else {
//                        self.getEditableVersion();
//                    }
//                    self.activityIndicator.startAnimating();
//                } else {
//                    self.bodyField.text = content.content.text;
//                    self.bodyField.becomeFirstResponder();
//                }
//                
//            }
//            
//        
//    }
    
//    func showEditableText( updatedContent:JiveContent )
//    {
//        let kFiveMinutes:NSTimeInterval  = 5 * 60;
//        
//        self.titleField.text = updatedContent.subject;
//        self.bodyField.text = updatedContent.content.text;
//        self.bodyField.becomeFirstResponder();
//        self.refreshLockTimer = NSTimer.scheduledTimerWithTimeInterval(kFiveMinutes, target: self, selector: "refreshLock", userInfo: nil, repeats: true)
//        
//    }
    
//    func getEditableVersion()
//    {
//        self.instance!.getEditableContent(self.content, withOptions: nil, onComplete: {
//            (updatedContent:JiveContent!) -> Void in
//            self.showEditableText(updatedContent)
//            }, onError: {
//                (error:NSError!) ->Void in
//                self.activityIndicator.stopAnimating();
//            })
//        
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        if self.content {
            self.title = self.content!.subject;
            self.titleField.text = self.content!.subject;

            var s: String = self.content!.content.text;
            s = s.stringByReplacingOccurrencesOfString("<body>", withString: "<body contenteditable=\"true\">", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            
            NSLog("%@", s)
            self.bodyWebField.loadHTMLString(s, baseURL: nil)

        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.refreshLockTimer {
            self.refreshLockTimer!.invalidate();
            self.refreshLockTimer = nil;
            if self.content!.type == JiveDocumentType {
                self.instance?.unlockContent(self.content, onComplete: {
                    ()->Void in
                    NSLog("unlockContent succeeded.");
                    }, onError: {
                        (error:NSError!) ->Void in
                        NSLog("unlockContent failed %@", error);
                    })
                
            }
        }
    }
    
    
    
    
    func refreshLock (){
        
        self.instance?.lockContentForEditing(self.content, withOptions: nil, onComplete: {
            (content:JiveContent!) -> Void in
            NSLog("lockContentForEditing complete? %@", content.content.editable);
            }, onError: {
                (error:NSError!)-> Void in
                NSLog("lockContentForEditing error %@", error);
            })
        
        
    }
    
    
    @IBAction func savePressed(sender:AnyObject){
        self.content!.subject = self.titleField.text;
        self.content!.content.text = self.bodyWebField.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML")

        self.instance?.saveContentWhileEditing(self.content, withOptions: nil, onComplete: {
            (content:JiveContent!) -> Void in
            self.activityIndicator.stopAnimating()
            }, onError: {
                (error:NSError!)-> Void in
                NSLog("saveContentWhileEditing failed %@", error);
                self.activityIndicator.stopAnimating();
            })
        
        
        self.activityIndicator.startAnimating()
    }
    
    
    
    
}