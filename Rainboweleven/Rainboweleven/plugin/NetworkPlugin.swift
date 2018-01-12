//
//  NetworkPlugin.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 12/18/17.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import Foundation
import Alamofire

public class NetWorkPlugin : RWebkitCustomPlugin {
    
    public var moduleName: String? {
        return "network"
    }
    
    public var actionMapping: [String : NativeAction]? {
        return ["get": doGet,
                "post": doPost]
    }
    
    public var customFuncMapping: [String : (String, NativeAction)]? {
        return nil
    }
    
    public static var shared: RWebkitCustomPlugin = NetWorkPlugin()
    
    fileprivate func doGet(_ callbackName: String?, _ args: Any, _ asyncCallBack: NativeCallback?) -> String {
        
        //
        responseDefaultCallback(callbackName: callbackName, "do Get Testing success ...", continuous: false, asyncCallBack: asyncCallBack)
        return ""
    }
    
    fileprivate func doPost(_ callbackName: String?, _ args: Any, _ asyncCallBack: NativeCallback?) -> String {
        
        //
        responseDefaultCallback(callbackName: callbackName, "do Post Testing success ...", continuous: false, asyncCallBack: asyncCallBack)
        
        return ""
    }
}
