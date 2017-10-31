//
//  RWebkitPluginsHub.swift
//  Rainboweleven
//
//  Created by chenshaomou on 24/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import Foundation

typealias PluginAction = (_ args:Any) -> String

class RWebkitPlugin {
    let name : String
    let action : PluginAction
    let module : String
    
    init(_ n:String,_ a:@escaping PluginAction,_ s:String = "userDefault") {
        self.name = n
        self.action = a
        self.module  = s
    }
    
    func getKey() -> String {
        return "\(module).\(name)"
    }
    
}

//插件管理器，单例实现
class RWebkitPluginsHub {
    
    static let shared = RWebkitPluginsHub.init()
    var plugins = [String : RWebkitPlugin]()
    
    private init(){
        //添加存储插件
        self.addPlugin(name: "getValue", module: "store") { (args) -> String in
            return "Hello,\(args)"
        }
    }
    
    func addPlugin(name:String,action:@escaping PluginAction ) {
        let _aplugin = RWebkitPlugin(name,action)
        plugins[_aplugin.getKey()] = _aplugin
    }
    
    func addPlugin(name:String,module:String,action:@escaping PluginAction ) {
        let _aplugin = RWebkitPlugin(name,action,module)
        plugins[_aplugin.getKey()] = _aplugin
    }
    
    func runPlugin(name:String,args:Any) -> String {
        //TODO: 不存在，报错
        guard let _plugin = plugins[name] else { return ""}
        return _plugin.action(args)
    }
    
    func getJSBridgeBuiltInScript()  -> String{
        let _scripts = plugins.reduce("") { (result, arg) -> String in
            let (key, plugin) = arg
            let _js = "if(undefined===jsBridge.\(plugin.module)){jsBridge.\(plugin.module)={}}jsBridge.\(key)=function(p,f){if(arguments.length===0){return jsBridge.call(\"\(key)\")}if(arguments.length===1){return  jsBridge.call(\"\(key)\",p)}if(arguments.length===2){jsBridge.call(\"\(key)\",p,f)}}"
            return result.appending(_js)
        }
        return ";\(_scripts)"
    }
}
