//
//  JVMasterViewController.swift
//  Nive
//
//  Created by Jay Li on 30/06/2014.
//  Copyright (c) 2014 Jay Li. All rights reserved.
//

import UIKit
class JVMasterViewController:UITableViewController{
    var me:JivePerson? ;
    var _objects:[JivePerson]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.me{
            _objects = [self.me!]
            
            var completBlock:JiveArrayCompleteBlock? = {
                (objects: [AnyObject]?) -> Void in
                self.addFollowers(objects! as [JivePerson])
            }
            
            self.me!.followingWithOptions(nil, onComplete: completBlock, onError: nil)
        }
    }
    
    func addFollowers(objects: [JivePerson]){
       _objects = _objects! + objects
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return _objects!.count
    }
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var  cell : JVPersonCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as JVPersonCell
        
        var object: JivePerson  = _objects![indexPath.row];
        cell.person = object
        return cell;
    }
    
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()
            
            var object: JivePerson = _objects![indexPath.row]
            
            (segue.destinationViewController as JVDetailViewController).detailItem = object
            
            
        }
    }
    
    
}


