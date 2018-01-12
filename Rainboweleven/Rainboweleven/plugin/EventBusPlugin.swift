//
//  EventBusPlugin.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/12/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

public class EventBusPlugin : RWebkitCustomPlugin {
    
    public static var shared: RWebkitCustomPlugin = EventBusPlugin()
    
    public var moduleName: String? {
        return "event"
    }
    
    public var actionMapping: [String : NativeAction]? {
        return ["on": eventOn,
                "off": eventOff,
                "send": eventSend]
    }
    
    // 回调存储  key: evenName value Event对象
    private var jsEventBus = [String : JSEvent]()
    
    public var customFuncMapping: [String : (String, NativeAction)]? {
        return nil 
    }
    
    func eventOn(_ callbackName: String?, _ args: Any, _ asyncCallBack: NativeCallback?) -> String {
        
        let event = JSEvent(args, action: asyncCallBack)
        event.action = { [weak self] (result) in
            
            guard let result = result else { return }
            
            switch result {
            case .success(let value):
              self?.responseDefaultCallback(callbackName: callbackName, value, continuous: true, asyncCallBack: asyncCallBack)
            case .failure(let error):
                print("error in eventOn callBackName =\(event.name) : \(error.localizedDescription)")
            }
        }
        
        jsEventBus[event.name] = event
        
        let nativeEvent = EventBus.wrap(From: event)
        nativeEvent?.addJSObserver(jsEvent: event)
        
        return ""
    }
    
    func eventOff(_ callbackName: String?, _ args: Any, _ asyncCallBack: NativeCallback?) -> String {
        
        let name = JSEvent(args, action: asyncCallBack).name
        if let jsEvent = jsEventBus[name] {
            let nativeEvent = EventBus.wrap(From: jsEvent)
            nativeEvent?.removeJSObserver(jsEvent: jsEvent)
        }
        
        jsEventBus[name] = nil
        
        return ""
    }
    
    func eventSend(_ callbackName: String?, _ args: Any, _ asyncCallBack: NativeCallback?) -> String {
        
        if let jsEvent = jsEventBus[JSEvent(args, action: asyncCallBack).name] {
            let nativeEvent = EventBus.wrap(From: jsEvent)
            nativeEvent?.onJSSend(args: args, jsEvent: jsEvent)
        }
        
        return ""
    }
}

public class JSEvent {
    
    public var name = ""
    
    public var params = [String : Any]()
    
    public var action:NativeCallback? = nil
    
    public init(_ args: Any, action: NativeCallback?) {
        
        guard let json = args as? String else {
            return
        }
        
        let jsonDic = json.seriailized()
        name = (jsonDic["eventName"] as? String) ?? ""
        params = (jsonDic["params"] as? [String : Any]) ?? [:]
        self.action = action
    }
}


