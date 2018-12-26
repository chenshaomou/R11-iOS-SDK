//
//  RWebkitPluginsHub.swift
//  Rainboweleven
//
//  Created by chenshaomou on 24/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import Foundation
// 原生结果回调
public typealias NativeCallback = (_ result:PluginResult?) -> Void


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
    public func addPlugin(plugin : RWebkitPlugin) {
        plugins[plugin.getKey()] = plugin
    }
    
    // 添加插件
    // name:插件名字
    // module:模块名字
    // action:插件原生实现函数
    public func addPlugin(name: String, module:String, action: @escaping Action) {
        let plugin = RWebkitPlugin(name, action, module)
        plugins[plugin.getKey()] = plugin
    }
    
    // 运行插件
    // name:插件名字
    // module:模块名字
    // args:入参
    // callbackName:回调名字
    // asyncCallBack: 原生结果回调
    @discardableResult
    public func runPlugin(name: String, module:String, args:Any) -> Promise {
        let _name = "\(module).\(name)"
        return runPlugin(name: _name, args: args)
    }
    
    // 运行插件 - 私有方法
    @discardableResult
    private func runPlugin(name: String, args: Any) -> Promise {
        if let plugin = plugins[name] {
            return plugin.action(args)
        } else if let defaultPlugin = plugins["userDefault.\(name)"]{
            return defaultPlugin.action(args)
        } else {
            return Promise(Promise.emptyValue)
        }
    }
    
    // 插件注入JS语句
    public func getJSBridgeBuiltInScript() -> String {
        // 普通插件
        registerDefaultPlugins()
        
        let _scripts = plugins.reduce("") { (result, arg) -> String in
            let (_, plugin) = arg
            return result.appending(plugin.registerPluginScript())
        }
        
        // promise 插件
        return ";\(_scripts)"
    }
    
    // 添加默认插件
    fileprivate func registerDefaultPlugins() {
        
        let appInfoModule = AppInfoModule()
        let eventsModule = EventsModule()
        let storeModule = StoreModule()
        let netWorkModule = NetworkModule()
        
        addPlugin(plugin: appInfoModule.version())
        addPlugin(plugin: eventsModule.eventTigger())
        addPlugin(plugin: storeModule.getValue())
        addPlugin(plugin: storeModule.setValue())
        addPlugin(plugin: storeModule.removeValue())
        addPlugin(plugin: netWorkModule.request())
    }
    
}
