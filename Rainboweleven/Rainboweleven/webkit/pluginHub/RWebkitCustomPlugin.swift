//
//  RWebViewCustomPlugin.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/12/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

public protocol RWebkitCustomPlugin {
    
    // 模块名称
    var moduleName : String? { get }
    
    // 插件闭包映射
    var actionMapping : [String: PluginAction]? { get }
    
    // 插件自定义回调映射
    var customFuncMapping : [String: String]? { get }
    
    // 单例
    static var shared : RWebkitCustomPlugin { get }
    
    // 注册插件 
    static func register()
}

extension RWebkitCustomPlugin {
    
    public static func register() {
        
        shared.actionMapping?.forEach { (name , action) in
            RWebkitPluginsHub.shared.addPlugin(name: name, module: shared.moduleName ?? "" , action: action)
        }
        
        shared.customFuncMapping?.forEach({ (name, customFunc) in
            
            RWebkitPluginsHub.shared.addPlugin(name: name, customFunc: customFunc, action: { _,_  in
                return ""
            })
        })
    }

}
