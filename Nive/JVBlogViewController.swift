//
//  JVBlogViewController.swift
//  Nive
//
//  Created by Jay Li on 30/06/2014.
//  Copyright (c) 2014 Jay Li. All rights reserved.
//

import UIKit
class JVBlogViewController:UITableViewController{
    var contents:[AnyObject]? {
    didSet{
        self.tableView.reloadData();
    }
    };
    
    
    func setTableView(tableView:UITableView ) {
        super.tableView = tableView
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if   self.contents {
           return self.contents!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var  CellIdentifier: String = "Post";
        var cell:UITableViewCell  = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as UITableViewCell
       
        
        if let post = self.contents![indexPath.row] as? JivePost {
            cell.textLabel.text = post.subject;
        }else {
            var post: JiveDocument  = self.contents![indexPath.row] as JiveDocument;
             cell.textLabel.text = post.subject;
        }
        
        return cell;
    }
    
    
    
}