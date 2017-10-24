//
//  RWebkitPluginsHub.swift
//  Rainboweleven
//
//  Created by chenshaomou on 24/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import Foundation

typealias JsCallback = (_ result : String)->Void
typealias PluginAction = (_ args:[String:Any],_ jsCallback:JsCallback) ->Void

class RWebkitPlugin {
    let name : String
    let action : PluginAction
    
    init(_ n:String,_ a:@escaping PluginAction) {
        self.name = n
        self.action = a
    }
}

//插件管理器，单例实现
class RWebkitPluginsHub {
    
    static let shared = RWebkitPluginsHub.init()
    var plugins = [String : RWebkitPlugin]()
    
    private init(){
        //添加存储插件
        self.addPlugin(name: "setValue") { (args, jsCallback) in
            NSLog("setValue...")
        }
    }
    
    func addPlugin(name:String,action:@escaping PluginAction ) {
        plugins[name] = RWebkitPlugin(name,action)
    }
    
}
