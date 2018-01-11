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
    
    public var actionMapping: [String : PluginAction]? {
        return ["get": doGet,
                "post": doPost]
    }
    
    public var customFuncMapping: [String : String]? {
        return nil
    }
    
    public static var shared: RWebkitCustomPlugin {
        return NetWorkPlugin()
    }
    
    fileprivate func doGet(_ args: Any, _ asyncCallBack: PluginResultCallBack?) -> String {
        
        let result = PluginResult.terminate("doGet Testing ... ")
        asyncCallBack?(result)
        
        return ""
    }
    
    fileprivate func doPost(_ args: Any, _ asyncCallBack: PluginResultCallBack?) -> String {
        
        let result = PluginResult.terminate("doPost Testing ... ")
        asyncCallBack?(result)
        
        return ""
    }
}
