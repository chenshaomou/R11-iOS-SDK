//
//  RWebView+Constants.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/11/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

extension RWebView {
    
    // window桥接对象命名
    private static let bridgeName = "jsBridge"
    
    // Prompt 桥接前缀 - 用于注入 & WKWebViewDelegate拦截
    internal static let promptPrefix = "_\(bridgeName)"
    
    // Prompt 桥接交接前缀 - 用于注入
    internal static let promptInjectPrefix = "_jswk"
    
    // Prompt js加载完毕标识
    internal static let jsDidInitial = "_jsinited"
    
    // 调用jsBridge.callbacks中的回调方法 - 用于原生异步回调
    internal static let jsBridgeCallBack = "window.\(bridgeName).callbacks.%@(decodeURIComponent(\"%@\"));"
    
    // 删除异步jsBridge.callbacks中的回调方法
    internal static let clearjsBridgeCallBack = "delete window.\(bridgeName).callbacks.%@;"
    
    // 注册插件
    internal static let createPluginOnJSBrige = "window.\(bridgeName).registerNative('%@','%@');"
    
    // 注册自定义回调插件
    internal static let createPluginOnJSBrigeWithCustomFunc = "window.\(bridgeName).registerNative('%@', '%@', %@);"
    
    // WebView初始化时候注入的初始化JS语句
    // 具体 rJsBridge.js
    internal static let initializedScript = "function initJsBridge(webViewType){window.jsBridge=window.jsBridge||{};window.jsBridge.callbacks=window.jsBridge.callbacks||[];window.jsBridge.callbackCount=window.jsBridge.callbackCount||0;window.jsBridge.webViewType=window.jsBridge.webViewType||webViewType;window.jsBridge.register=window.jsBridge.register||function(module,method,callFun){if(arguments.length==2){callFun=method;method=module;module='userDefault'}else{if(arguments.length==3){}else{throw'register方法必须是2个或者3个参数'}}var action={};action[method]=callFun;window.jsBridge[module]=window.jsBridge[module]||{};Object.assign(window.jsBridge[module],action)};window.jsBridge.registerNative=window.jsBridge.registerNative||function(module,method,customFun){var lastArg=arguments[arguments.length-1];var hasCustomFun=typeof lastArg=='function';if(arguments.length==1){if(hasCustomFun){throw'registerNative不支持1个为function的参数'}else{method=module;module='userDefault'}}else{if(arguments.length==2){if(hasCustomFun){customFun=method;method=module;module='userDefault'}else{}}else{if(arguments.length==3){}else{throw'registerNative方法必须是1~3个参数'}}}var action={};if(hasCustomFun){action[method]=customFun}else{action[method]=function(params,callback){if(arguments.length===0){return window.jsBridge.call(module,method,{})}if(arguments.length===1){return window.jsBridge.call(module,method,params)}if(arguments.length===2){window.jsBridge.call(module,method,params,callback)}}}window.jsBridge[module]=window.jsBridge[module]||{};Object.assign(window.jsBridge[module],action)};window.jsBridge.call=window.jsBridge.call||function(module,method,params,callback){var lastArg=arguments[arguments.length-1];var async=typeof lastArg=='function';if(arguments.length==3){if(async){callback=params;params=method;method=module;module='userDefault'}else{}}else{if(arguments.length==4){}else{throw'register方法必须是3个或者4个参数'}}if(typeof params!='string'){if(typeof params=='object'||Object.prototype.toString.call(params)=='[object Array]'){params=JSON.stringify(params||{})}else{params=params.toString()}}var request;if(async){var callbackName=module+'_'+method+'_'+window.jsBridge.callbackCount++;window.jsBridge.callbacks[callbackName]=callback;request={'module':module,'method':method,'params':params,'callbackName':callbackName}}else{request={'module':module,'method':method,'params':params}}var requestStr=JSON.stringify(request||{});if(window.jsBridge.webViewType=='WKWV'){if(async){window.prompt(window.\(promptInjectPrefix),requestStr)}else{return window.prompt(window.\(promptInjectPrefix),requestStr)}}else{if(typeof window.nativeBridge=='function'){if(async){window.nativeBridge(requestStr)}else{return window.nativeBridge(requestStr)}}else{if(typeof window.nativeBridge=='object'){if(async){window.nativeBridge.call(requestStr)}else{return window.nativeBridge.call(requestStr)}}else{console.log('无window.nativeBridge被注册')}}}};window.jsBridge.promise=window.jsBridge.promise||function(module,method,params){return new Promise(function(resolve,reject){try{window.jsBridge.call(module,method,params,function(result){resolve(result)})}catch(e){reject(e)}})};window.jsBridge.on=window.jsBridge.on||function(eventName,callback){window.jsBridge.call('event','on',{'eventName':eventName},callback)};window.jsBridge.off=window.jsBridge.off||function(eventName){return window.jsBridge.call('event','off',{'eventName':eventName})};window.jsBridge.send=window.jsBridge.send||function(eventName,params){return window.jsBridge.call('event','send',{'eventName':eventName,'params':params})};window.jsBridge.sendDocumentEvent=window.jsBridge.sendDocumentEvent||function(eventName,cancelable){var event=window.document.createEvent('Event');if(arguments.length==1||typeof cancelable=='undefined'){cancelable=false}event.initEvent(eventName,false,cancelable);window.document.dispatchEvent(event)}}initJsBridge('WKWV');"
    
}
