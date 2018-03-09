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
    internal static let sendDocumentEvent = "window.\(bridgeName).sendDocumentEvent('%@');"
    
    // WebView初始化时候注入的初始化JS语句
    // 具体 rJsBridge.js
    internal static let initializedScript = "function initJsBridge(g){window.jsBridge=window.jsBridge||{};window.jsBridge.callbacks=window.jsBridge.callbacks||[];window.jsBridge.callbackCount=window.jsBridge.callbackCount||0;window.jsBridge.webViewType=window.jsBridge.webViewType||g;window.jsBridge.register=window.jsBridge.register||function(a,b,c){if(2==arguments.length)c=b,b=a,a='userDefault';else if(3!=arguments.length)throw'register method must be 2 or 3 params';var e={};e[b]=c;window.jsBridge[a]=window.jsBridge[a]||{};Object.assign(window.jsBridge[a],e)};window.jsBridge.call=window.jsBridge.call||function(a,b,c,e){var f='function'==typeof arguments[arguments.length-1];if(3==arguments.length)f&&(e=c,c=b,b=a,a='userDefault');else if(4!=arguments.length)throw'register method must be 3 or 4 params';'string'!=typeof c&&(c='object'==typeof c||'[object Array]'==Object.prototype.toString.call(c)?JSON.stringify(c||{}):c.toString());var d;f?(d=a+'_'+b+'_'+window.jsBridge.callbackCount++,window.jsBridge.callbacks[d]=e,d={module:a,method:b,params:c,callbackName:d}):    d={module:a,method:b,params:c};d=JSON.stringify(d||{});if('WKWV'==window.jsBridge.webViewType)if(f)window.prompt(window.jsBridge.webViewType,d);else return window.prompt(window.jsBridge.webViewType,d);else if('function'==typeof window.nativeBridge)if(f)window.nativeBridge(d);else return window.nativeBridge(d);else if('object'==typeof window.nativeBridge)if(f)window.nativeBridge.call(d);else return window.nativeBridge.call(d);else console.log('no window.nativeBridge has been registered')};window.jsBridge.promise=window.jsBridge.promise||function(a,b,c){return new Promise(function(e,f){try{window.jsBridge.call(a,b,c,function(a){e(a)})}catch(d){f(d)}})};window.jsBridge.on=window.jsBridge.on||function(a,b){window.jsBridge.call('event','on',{eventName:a},b)};window.jsBridge.off=window.jsBridge.off||function(a){return window.jsBridge.call('event','off',{eventName:a})};window.jsBridge.send=window.jsBridge.send||function(a,b){return window.jsBridge.call('event','send',{eventName:a,params:b})};window.jsBridge.sendDocumentEvent=window.jsBridge.sendDocumentEvent||function(a,b){var c=window.document.createEvent('Event');if(1==arguments.length||'undefined'==typeof b)b=!1;c.initEvent(a,!1,b);window.document.dispatchEvent(c)}}initJsBridge('WKWV');"
}
