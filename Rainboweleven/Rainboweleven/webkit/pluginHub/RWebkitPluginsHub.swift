//
//  RWebkitPluginsHub.swift
//  Rainboweleven
//
//  Created by chenshaomou on 24/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import Foundation

// 插件回调
public enum PluginResult {
    
    // 持续回调, 回调后js的callback对象不会删除仍挂在window.jsbridge上
    case continuous(String)
    // 终结回调, 回调后js的callback对象将被删除
    case terminate(String)
    
}

public typealias PluginResultCallBack = (_ result:PluginResult?) -> Void

public typealias PluginAction = (_ args: Any, _ asyncCallBack: PluginResultCallBack?) -> String

// 插件管理器，单例实现
public class RWebkitPluginsHub {
    
    public static let shared = RWebkitPluginsHub()
    
    fileprivate var plugins = [String : RWebkitPlugin]()
    
    private init(){
    }
    
    public func addPlugin(name:String, customFunc: String? = nil, action:@escaping PluginAction) {
        let plugin = RWebkitPlugin(name, action)
        plugin.customFunc = customFunc
        plugins[plugin.getKey()] = plugin
    }
    
    public func addPlugin(name:String, module:String, customFunc: String? = nil, action:@escaping PluginAction) {
        let plugin = RWebkitPlugin(name, action, module)
        plugin.customFunc = customFunc
        plugins[plugin.getKey()] = plugin
    }
    
    @discardableResult
    public func runPlugin(name:String, args: Any, asyncCallBack: PluginResultCallBack? = nil) -> String {
        
        if let plugin = plugins[name]{
            return plugin.action(args, asyncCallBack)
        } else if let defaultPlugin = plugins["userDefault.\(name)"]{
            return defaultPlugin.action(args, asyncCallBack)
        } else {
            return ""
        }
    }
    
    @discardableResult
    public func runPlugin(name:String, module:String, args:Any, asyncCallBack: PluginResultCallBack? = nil) -> String {
        let _name = "\(module).\(name)"
        return runPlugin(name: _name, args: args, asyncCallBack: asyncCallBack)
    }
    
    // 添加默认插件
    fileprivate func registerDefaultPlugin() {
        AppInfoPlugin.register()
        NetWorkPlugin.register()
    }
    
    public func getJSBridgeBuiltInScript() -> String {
        
        //
        registerDefaultPlugin()
        
        let _scripts = plugins.reduce("") { (result, arg) -> String in
            let (_, plugin) = arg
            return result.appending(plugin.reginsterPluginScript())
        }
        return ";\(_scripts)"
    }
}
