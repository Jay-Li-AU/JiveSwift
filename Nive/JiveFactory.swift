//
//  JiveFactory.swift
//  Nive
//
//  Created by Jay Li on 26/06/2014.
//  Copyright (c) 2014 Jay Li. All rights reserved.
//


class SingletonB{
    var instance: JVJiveFactory?
}

class JVJiveFactory: NSObject, JiveAuthorizationDelegate{
    class var initialized:Bool {
        get {
        return false
        }
        set {
            NSLog("test")
        }
    }
    
    
    
    class var sharedInstance : SingletonB {
        struct Static {
            static let instance : SingletonB = SingletonB()
        }
        return Static.instance
    }
    
    var  userName:String? = "";
    var  password:String? = "";
    var  jive:Jive?;
    var  credentials:JiveCredentials?;
    var  mobileAnalyticsHeader:JiveMobileAnalyticsHeader?;
    
    
    class func currentInstance()-> JVJiveFactory {
        return sharedInstance.instance!
    }
    
    
    class func setInstance(instance:JVJiveFactory) {
        NSLog("set Instance %@", instance)
        sharedInstance.instance = instance
    }
    
    
    init(instanceURL:NSURL?, completeBlock:JivePlatformVersionBlock?, errorBlock:JiveErrorBlock?){
        super.init()
        if instanceURL != nil {
            JVJiveFactory.initialized = true
            var x: JiveAuthorizationDelegate? = self
            self.jive = Jive(jiveInstance: instanceURL, authorizationDelegate: x!)
            
            NSLog("jive is not null %@", self.jive! )
            
            
            
            self.jive?.versionForInstance(instanceURL, onComplete: completeBlock, onError: errorBlock)
        }
        
        
    }
    func handleLoginError(error: NSError, withErrorBlock errorBlockCopy:JiveErrorBlock?)
    {
        self.userName = nil;
        self.password = nil;
        self.jive = nil;
        if (errorBlockCopy) {
            errorBlockCopy!(error);
        }
    }
    
    
    func loginWithNewInstanceURL(instanceURL:NSURL? ,me:JivePerson ,completeBlock:JivePersonCompleteBlock?)
    {
        // Make sure we have the correct me object.
        var oldJive:Jive = self.jive!;
        
        var errorBlock = {
            (error: NSError?) -> Void in
            self.jive = oldJive
            if completeBlock {
                completeBlock!(me)
            }
        }
        
        var x: JiveAuthorizationDelegate? = self
        self.jive = Jive(jiveInstance: instanceURL, authorizationDelegate: x)
        self.jive?.me(completeBlock, onError:errorBlock)
        
        
    }
    
    func doubleCheckInstanceURLForMe(me:JivePerson, onComplete completeBlock:JivePersonCompleteBlock?)
    {
        self.jive?.propertyWithName(JivePropertyNames.instanceURL, onComplete:
            {(property:JiveProperty!) -> Void in
                var instanceString:NSString!  = property.valueAsString();
                
                // The SDK assumes the URL has a / at the end. So make sure it does.
                if instanceString.hasSuffix("/")  {
                    instanceString = instanceString.stringByAppendingString("/")
                }
                
                var instanceURL: NSURL  = NSURL.URLWithString(instanceString);
                
                // Yes! We have a server url.
                if instanceString.isEqualToString(self.jive?.jiveInstanceURL.absoluteString)  {
                    // Everything matches up.
                    if completeBlock  {
                        completeBlock!(me);
                    }
                } else {
                    self.loginWithNewInstanceURL(instanceURL, me: me, completeBlock: completeBlock) ;
                }
            }, onError: {(error: NSError?) -> Void in
                
                if completeBlock {
                    completeBlock!(me)
                }
                
                
            })
        
    }
    
    
    
    func loginWithName(userName:String,
        password:String ,
        complete completeBlock:JivePersonCompleteBlock?,
        error errorBlock:JiveErrorBlock) {
            var errorBlockCopy:JiveErrorBlock  = errorBlock;
            
            self.userName = userName;
            self.password = password;
            self.credentials = nil;
            
            
            if self.jive {
                self.jive!.me({
                    (me:JivePerson?)->Void in
                    var platformVersion:JivePlatformVersion  = self.jive!.platformVersion;
                    
                    // url check.
                    if platformVersion.instanceURL != nil {
                        // It's all good.
                        if completeBlock {
                            completeBlock!(me);
                        }
                    } else {
                        // NO!!! We have to make sure we have the right URL.
                        self.doubleCheckInstanceURLForMe(me!, onComplete: completeBlock)
                        
                    }
                    }, onError:
                    {
                        (error:NSError!)->Void in
                        self.handleLoginError(error, withErrorBlock: errorBlockCopy)
                    }
                )
            }
            
    }
    
    class func loginWithName(userName: String, password:String,
        complete completeBlock:JivePersonCompleteBlock?,
        error errorBlock:JiveErrorBlock) {
            currentInstance().loginWithName(userName, password: password, complete: completeBlock, error: errorBlock)
            
    }
    
    
    
    
    func credentialsForJiveInstance(url: NSURL!) -> JiveCredentials! {
        if(!self.credentials){
            self.credentials = JiveHTTPBasicAuthCredentials(username: self.userName, password: self.password)
        }
        return self.credentials
    }
    
    
    
    func mobileAnalyticsHeaderForJiveInstance(url: NSURL!) -> JiveMobileAnalyticsHeader! {
        if(!self.mobileAnalyticsHeader){
            self.mobileAnalyticsHeader = JiveMobileAnalyticsHeader(appID: "Example Jive iOS SDK app", appVersion: "%1$@ (%2$@)", connectionType:NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as String
                ,devicePlatform: NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as String, deviceVersion: UIDevice.currentDevice().systemVersion)
        }
        
        return self.mobileAnalyticsHeader
    }
    
    
    
}
