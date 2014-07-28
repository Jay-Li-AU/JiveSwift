//
//  JVDetailViewController.swift
//  Nive
//
//  Created by Jay Li on 30/06/2014.
//  Copyright (c) 2014 Jay Li. All rights reserved.
//

import UIKit
class JVDetailViewController: UIViewController,UITabBarDelegate{
    var detailItem:JivePerson? {
    didSet{
        if detailItem != oldValue{
            changed = true
        }else{
            changed = false
        }
    }
    }
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!;
    @IBOutlet weak var tableView:UITableView! ;
    @IBOutlet weak var tabBar:UITabBar! ;
    
    var  tableViewController:JVBlogViewController?
    var blog:JiveBlog? {
    didSet{
        var jive: Jive  = self.detailItem!.jiveInstance;
        var operation: NSOperation  = jive.contentsOperationWithURL(blog!.contentsRef(), onComplete: {
            (contents:[AnyObject]!)->Void in
            self.activityIndicator.stopAnimating()
            self.blogPosts = contents
            
            if (self.tabBar.selectedItem.tag == 0) {
                (self.tableViewController? as JVBlogViewController).contents = contents;
            }
            }, onError: {
                (error:NSError!)->Void in
                self.activityIndicator.stopAnimating()
            })
        
        self.title = blog!.name;
        self.operationQueue?.addOperation(operation)
        loadDocs()
    }
    }
    var operationQueue: NSOperationQueue?
    var blogPosts:[AnyObject]?
    var authoredDocuments:[AnyObject]?
    var changed:Bool = true
    
    func load()
    {
        
        self.title = self.detailItem!.displayName;
        var jive: Jive  = self.detailItem!.jiveInstance;
        
        if detailItem!.blogRef() != nil {
            detailItem!.blogWithOptions(nil, onComplete: {
                (blog:JiveBlog!)->Void in
                self.blog = blog
                }, onError: {
                    (error:NSError!)->Void in
                })
        }else {
            self.tabBar.selectedItem = self.tabBar.items[1] as UITabBarItem
            loadDocs()
        }
        
    }
    
    
    func loadDocs( ){
        var jive: Jive  = self.detailItem!.jiveInstance;
        var authoredContentOptions:JiveContentRequestOptions  = JiveContentRequestOptions();
        authoredContentOptions.addAuthor(self.detailItem!.selfRef())
        authoredContentOptions.addType(JiveDocumentType)
        
        var operation:NSOperation = jive.contentsOperation(authoredContentOptions,  onComplete: {
            (authoredDocuments:[AnyObject]!) -> Void in
            self.activityIndicator.stopAnimating()
            self.authoredDocuments = authoredDocuments;
            if  self.tabBar.selectedItem.tag == 1 {
                (self.tableViewController? as JVBlogViewController).contents = authoredDocuments;
            }
            }, onError: {
                (error:NSError!)->Void in
                self.activityIndicator.stopAnimating()
            })
        
        
        self.operationQueue?.addOperation(operation);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.selectedItem = self.tabBar.items[0] as UITabBarItem
        self.operationQueue = NSOperationQueue ()
        self.operationQueue!.maxConcurrentOperationCount = 1;
        self.tableViewController = JVBlogViewController();
        if self.tableViewController {
            self.tableViewController!.setTableView(self.tableView) ;
        }
        self.activityIndicator.startAnimating();
        load()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var indexPath:NSIndexPath  = self.tableView.indexPathForSelectedRow();
        var object:JiveContent  = (self.tableViewController as JVBlogViewController).contents![indexPath.row] as JiveContent;
        if segue.identifier == "beginEditing" {
            
           
            var editingViewController:JVEditingViewController  = segue.destinationViewController as JVEditingViewController;
            
            editingViewController.instance = self.detailItem!.jiveInstance;
            editingViewController.content = object;
        }else if  segue.identifier == "beginDisplay" {
            
            
            var editingViewController:JVWebViewController  = segue.destinationViewController as JVWebViewController;
            
            editingViewController.instance = self.detailItem!.jiveInstance;
            editingViewController.content = object;
        }
        
    }
    
    func tabBar(tabBar: UITabBar!, didSelectItem item: UITabBarItem!) {
        switch (item.tag) {
        case 0:
            (self.tableViewController as JVBlogViewController).contents = self.blogPosts;
            break;
            
        case 1:
            (self.tableViewController as JVBlogViewController).contents = self.authoredDocuments;
            break;
            
        default:
            (self.tableViewController as JVBlogViewController).contents = nil;
            break;
        }
    }
    
    
    
    
    
}