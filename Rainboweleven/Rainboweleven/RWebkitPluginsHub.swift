//
//  RWebkitPluginsHub.swift
//  Rainboweleven
//
//  Created by chenshaomou on 24/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import Foundation

typealias JsCallback = (_ result : String?)->Void
typealias AsyncPluginAction = (_ args:[String:Any],_ jsCallback:JsCallback) ->Void
typealias SyncPluginAction = (_ args:[String:Any]) -> String

class RWebkitPlugin {
    let name : String
    var asyncAction : AsyncPluginAction?
    var syncAction : SyncPluginAction?
    
    init(_ n:String,_ a:@escaping AsyncPluginAction) {
        self.name = n
        self.asyncAction = a
    }
    
    init(_ n:String,_ a:@escaping SyncPluginAction) {
        self.name = n
        self.syncAction = a
    }
}

//插件管理器，单例实现
class RWebkitPluginsHub {
    
    static let shared = RWebkitPluginsHub.init()
    var asyncPlugins = [String : RWebkitPlugin]() //存储异步插件
    var syncPlugins = [String : RWebkitPlugin]() //存储同步插件
    
    private init(){
        //添加存储插件
        self.addASyncPlugin(name: "setValue") { (args, jsCallback) in
            NSLog("setValue...")
            jsCallback("")
        }
        
        self.addSyncPlugin(name: "getValue") { (args) -> String in
            return "Hello"
        }
    }
    
    func addASyncPlugin(name:String,action:@escaping AsyncPluginAction ) {
        asyncPlugins[name] = RWebkitPlugin(name,action)
    }
    
    func addSyncPlugin(name:String,action:@escaping SyncPluginAction){
        syncPlugins[name] = RWebkitPlugin(name,action)
    }
    
    func runPluginSync(name:String,args:[String:Any]) -> String {
        //TODO: 不存在，报错
        guard let _plugin = syncPlugins[name] else { return ""}
        if let _syncAction = _plugin.syncAction{
            return _syncAction(args)
        }else{
            //TODO: 不存在，报错
            return ""
        }
    }
    
    func runPluginASync(name:String,args:[String:Any],jsCallback:JsCallback){
        guard let _plugin = asyncPlugins[name] else { return}
        if let _asyncAction = _plugin.asyncAction{
            _asyncAction(args,jsCallback)
        }else{
            //TODO: 不存在，报错
        }
    }
    
    
    
}
