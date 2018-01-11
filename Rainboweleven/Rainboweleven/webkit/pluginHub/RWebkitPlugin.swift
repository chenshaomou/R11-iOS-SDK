//
//  RWebPlugin.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/11/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

public class RWebkitPlugin {
    
    public let name : String
    
    public let action : PluginAction
    
    public let module : String
    
    public var callbackName : String? = nil
    
    public var customFunc : String? = nil
    
    public init(_ name:String, _ action:@escaping PluginAction, _ module:String = "userDefault", _ customFunc: String? = nil) {
        self.name = name
        self.action = action
        self.module  = module
        self.customFunc = customFunc
    }
    
    public init(jsonDic: [String: Any]) {
        
        if let name = jsonDic["method"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let module = jsonDic["module"] as? String {
            self.module = module
        } else {
            self.module = ""
        }
        
        self.callbackName = jsonDic["callbackName"] as? String
        
        self.customFunc = nil
        
        action = { _,_  in
            return ""
        }
    }
    
    public func getKey() -> String {
        return "\(module).\(name)"
    }
    
    public func reginsterPluginScript() -> String {
        
        if let customFunc = self.customFunc {
            return NSString(format: RWebView.createPluginOnJSBrigeWithCustomFunc as NSString, self.module, self.name, customFunc) as String
        } else {
            return NSString(format: RWebView.createPluginOnJSBrige as NSString, self.module, self.name) as String
        }
        
    }
    
}
