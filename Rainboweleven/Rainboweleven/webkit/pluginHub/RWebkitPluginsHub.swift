//
//  RWebkitPluginsHub.swift
//  Rainboweleven
//
//  Created by chenshaomou on 24/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import Foundation

// 插件结果枚举
public enum PluginResult {
    // 成功并返回JS语句
    case success(String)
    // 失败
    case failure(Error)
}

// 原生结果回调
public typealias NativeCallback = (_ result:PluginResult?) -> Void

// 原生插件函数类型
// * 若不实现该方法，则插件无效
// callbackName : js回调函数引用
// args : js传入的参数
// asyncCallBack : 原生回调
public typealias NativeAction = (_ callbackName: String?, _ args: Any, _ asyncCallBack: NativeCallback?) -> String

// 插件管理器
public class RWebkitPluginsHub {
    
    // 单例实现
    public static let shared = RWebkitPluginsHub()
    
    // 插件缓存
    fileprivate var plugins = [String : RWebkitPlugin]()
    
    private init(){}
    
    // 添加插件
    // name:插件名字
    // module:模块名字
    // action:插件原生实现函数
    public func addPlugin(name: String, module:String, customFunc: String? = nil, action: @escaping NativeAction) {
        
        let plugin = RWebkitPlugin(name, action, module)
    
        plugin.customFunc = customFunc
        
        plugins[plugin.getKey()] = plugin
    
    }
    
    // 运行插件
    // name:插件名字
    // module:模块名字
    // args:入参
    // callbackName:回调名字
    // asyncCallBack: 原生结果回调
    @discardableResult
    public func runPlugin(name: String, module:String, args:Any, callbackName: String? = nil, asyncCallBack: NativeCallback? = nil) -> String {
        let _name = "\(module).\(name)"
        return runPlugin(name: _name, args: args, callbackName: callbackName, asyncCallBack: asyncCallBack)
    }
    
    // 运行插件 - 私有方法
    @discardableResult
    private func runPlugin(name: String, args: Any, callbackName: String? = nil, asyncCallBack: NativeCallback? = nil) -> String {
        
        if let plugin = plugins[name] {
            //
            plugin.callbackName = callbackName
            return plugin.action(callbackName, args, asyncCallBack)
        
        } else if let defaultPlugin = plugins["userDefault.\(name)"]{
            //
            defaultPlugin.callbackName = callbackName
            return defaultPlugin.action(callbackName, args, asyncCallBack)
        
        } else {
            //
            return ""
        }
    }
    
    // 插件注入JS语句
    public func getJSBridgeBuiltInScript() -> String {
        
        //
        registerDefaultPlugin()
        
        let _scripts = plugins.reduce("") { (result, arg) -> String in
            let (_, plugin) = arg
            return result.appending(plugin.reginsterPluginScript())
        }
        return ";\(_scripts)"
    }
    
    // 添加默认插件
    fileprivate func registerDefaultPlugin() {
        
        AppInfoPlugin.register()
        
        NetWorkPlugin.register()
        
        EventBusPlugin.register()
    }
    
}
