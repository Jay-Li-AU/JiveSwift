//
//  JVPersonCell.swift
//  Nive
//
//  Created by Jay Li on 30/06/2014.
//  Copyright (c) 2014 Jay Li. All rights reserved.
//



import UIKit
class JVPersonCell: UITableViewCell{
    @IBOutlet weak var  avatar:UIImageView!;
    @IBOutlet weak var name:UILabel! ;
    
    var person:JivePerson?{
    
    didSet{
        NSLog("setPerson %@", person!)
        if self.person != oldValue {
            
            var avatarCache:NSMutableDictionary?  = nil;
            
            if (!avatarCache) {
                avatarCache = NSMutableDictionary.dictionary()
            }
            
            var avatarRef:NSURL  = person!.avatarRef();
            var storedAvatarImage:UIImage?  = avatarCache![avatarRef] as? UIImage;
            
            
            self.name.text = person!.displayName;
            self.avatar.image = storedAvatarImage;
            if !storedAvatarImage {
                person!.avatarOnComplete({
                    (avatarImage:UIImage!)->Void in
                    avatarCache![avatarRef] = avatarImage
                    if self.person!.avatarRef() == avatarRef {
                        self.avatar.image = avatarImage;
                    }
                    }, onError: nil)
                
            }
            
        }
    }
    }
    
    
}
