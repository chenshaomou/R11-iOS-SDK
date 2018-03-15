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
    
    // 调用jsBridge.callbacks中的回调方法 - 用于原生异步回调
    internal static let jsBridgeCallBack = "window.\(bridgeName).callbacks.%@(%@);"
    
    // 删除异步jsBridge.callbacks中的回调方法
    internal static let clearjsBridgeCallBack = "delete window.\(bridgeName).callbacks.%@;"
    
    // 发送文档事件
    internal static let jsEventTigger = "window.\(bridgeName).events.tigger('%@','%@');"
    
    // WebView初始化时候注入的初始化JS语句
    // 具体 rJsBridge.js
    internal static let initializedScript = "function initJsBridge(webViewType){window.jsBridge=window.jsBridge||{};window.jsBridge.callbacks=window.jsBridge.callbacks||[];window.jsBridge.callbackCount=window.jsBridge.callbackCount||0;window.jsBridge.webViewType=window.jsBridge.webViewType||webViewType;window.jsBridge.register=window.jsBridge.register||function(module,method,callFun){if(arguments.length==2){callFun=method;method=module;module='userDefault'}else{if(arguments.length==3){}else{throw'register method must be 2 or 3 params'}}var action={};action[method]=callFun;window.jsBridge[module]=window.jsBridge[module]||{};Object.assign(window.jsBridge[module],action)};window.jsBridge.call=window.jsBridge.call||function(module,method,params,callback){var lastArg=arguments[arguments.length-1];var async=typeof lastArg=='function';if(arguments.length==3){if(async){callback=params;params=''}else{}}else{if(arguments.length==4){}else{throw'register method must be 3 or 4 params'}}if(typeof params!='string'){if(typeof params=='object'||Object.prototype.toString.call(params)=='[object Array]'){params=JSON.stringify(params||{})}else{params=params.toString()}}var request;if(async){var callbackName=module+'_'+method+'_'+window.jsBridge.callbackCount++;window.jsBridge.callbacks[callbackName]=callback;request={'module':module,'method':method,'params':params,'callbackName':callbackName}}else{request={'module':module,'method':method,'params':params}}var requestStr=JSON.stringify(request||{});if(window.jsBridge.webViewType=='WKWV'){if(async){window.prompt(window.jsBridge.webViewType,requestStr)}else{return window.prompt(window.jsBridge.webViewType,requestStr)}}else{if(typeof window.nativeBridge=='function'){if(async){window.nativeBridge(requestStr)}else{return window.nativeBridge(requestStr)}}else{if(typeof window.nativeBridge=='object'){if(async){window.nativeBridge.call(requestStr)}else{return window.nativeBridge.call(requestStr)}}else{console.log('no window.nativeBridge has been registered')}}}};window.jsBridge.promise=window.jsBridge.promise||function(module,method,params){return new Promise(function(resolve,reject){try{window.jsBridge.call(module,method,params,function(result){resolve(result)})}catch(e){reject(e)}})};window.jsBridge.on=window.jsBridge.on||function(eventName,observerKey,callback){var lastArg=arguments[arguments.length-1];window.jsBridge.events=window.jsBridge.events||{};window.jsBridge.events.observers=window.jsBridge.events.observers||{};if(typeof lastArg=='function'){if(arguments.length<3){callback=observerKey;observerKey='window.jsBridge'}window.jsBridge.events.observers[eventName]=window.jsBridge.events.observers[eventName]||{};window.jsBridge.events.observers[eventName][observerKey]=callback}else{throw'callback must de a function'}};window.jsBridge.off=window.jsBridge.off||function(eventName,observerKey){window.jsBridge.events=window.jsBridge.events||{};window.jsBridge.events.observers=window.jsBridge.events.observers||{};if(arguments.length<2){observerKey='window.jsBridge'}if(window.jsBridge.events.observers[eventName]&&window.jsBridge.events.observers[eventName][observerKey]){delete window.jsBridge.events.observers[eventName][observerKey]}};window.jsBridge.send=window.jsBridge.send||function(eventName,params){return window.jsBridge.call('events','send',{'eventName':eventName,'params':params})};window.jsBridge.register('events','tigger',function(eventName,params){window.jsBridge.events=window.jsBridge.events||{};window.jsBridge.events.observers=window.jsBridge.events.observers||{};if(window.jsBridge.events.observers[eventName]){Object.keys(window.jsBridge.events.observers[eventName]).every(function(element,index,array){window.jsBridge.events.observers[eventName][element](params)})}})}initJsBridge('WKWV');jsBridge.send('domLoadFinish');"
}
