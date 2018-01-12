//
//  RWebViewCustomPlugin.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/12/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

// MARK: - 自定义插件协议
public protocol RWebkitCustomPlugin {
    
    // MARK: 需要实现接口
    // 模块名称
    var moduleName : String? { get }
    
    // 插件闭包映射 key 插件名称 value 回调方法
    var actionMapping : [String: NativeAction]? { get }
    
    // 插件自定义回调映射 key 插件名称 value （自定义函数,插件）
    var customFuncMapping : [String : (String, NativeAction)]? { get }
    
    // 单例
    static var shared : RWebkitCustomPlugin { get }
    
    // MARK: 实现方法
    // 注册插件 
    static func register()
    
    // 异步调用默认插件回调
    // callbackName : 回调名称
    // value : 回调结果
    // continuous : 保持回调 默认false
    // asyncCallBack : 异步回调
    func responseDefaultCallback(callbackName:String?, _ value: String, continuous: Bool, asyncCallBack: NativeCallback?)
    
    // 异步调用自定义插件回调
    // callbackName : 回调名称
    // args : 回调结果
    // continuous : 保持回调 默认false
    // asyncCallBack : 异步回调
    func responseCustomFunc(callbackName:String?, _ args: [String], continuous: Bool, asyncCallBack: NativeCallback?)
}

extension RWebkitCustomPlugin {
    
    public static func register() {
        
        shared.actionMapping?.forEach { (name , action) in
            RWebkitPluginsHub.shared.addPlugin(name: name, module: shared.moduleName ?? "" , action: action)
        }
        
        shared.customFuncMapping?.forEach({ (name, value) in
            RWebkitPluginsHub.shared.addPlugin(name: name, module: shared.moduleName ?? "", customFunc: value.0, action: value.1)
        })
        
    }
    
    public func responseDefaultCallback(callbackName:String?, _ value: String, continuous: Bool = false, asyncCallBack: NativeCallback?) {
        
        guard let callback = callbackName else { return }
        
        var res = "\"{}\""
        if !value.isEmpty, let args = value.encodingValue {
            res = args
        }
        
        let script = String(format: RWebView.jsBridgeCallBack, callback, res)
        response(callbackName: callback, script: script, continuous: continuous, asyncCallback: asyncCallBack)
        
    }
    
    public func responseCustomFunc(callbackName:String?, _ args: [String], continuous: Bool = false, asyncCallBack: NativeCallback?) {
        
        guard let callback = callbackName else { return }
        
        var result = [callback]
        args.forEach { (value) in
            
            if let res = value.encodingValue {
                result.append(res)
            } else {
                return
            }
        }
        
        let script = String(format: RWebView.jsBridgeCallBack, arguments: result)
        response(callbackName: callback, script: script, continuous: continuous, asyncCallback: asyncCallBack)
    }
    
    // 回调到JS
    // callbackName : 回调名称
    // script : 回调JS语句
    // continuous : 保持回调
    // asyncCallBack : 异步回调
    private func response(callbackName: String, script: String, continuous: Bool, asyncCallback: NativeCallback?) {
        
        var response = script
        if !continuous {
            // 若不保持回调，则再JSBridge删除callback对象
            response += String(format: RWebView.clearjsBridgeCallBack, callbackName)
        }
        asyncCallback?(PluginResult.success(response))
    }
}

// MARK: - URL Encode
extension String {
    
    // 对返回参数进行 URL Encode 防止中文乱码
    fileprivate var encodingValue : String? {
        
        if let res =  self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return "decodeURIComponent('\(res)')"
        }
        return ""
    }
}
