//
//  EventBusPlugin.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/12/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

public class EventBusPlugin : RWebkitCustomPlugin {
    
    public static var shared: RWebkitCustomPlugin {
        return EventBusPlugin()
    }
    
    public var moduleName: String? {
        return "event"
    }
    
    public var actionMapping: [String : PluginAction]? {
        return ["on": eventOn,
                "off": eventOff,
                "send": eventSend]
    }
    
    private var bus = [String : Event]()
    
    public var customFuncMapping: [String : String]? {
        return nil 
    }
    
    func eventOn(_ args: Any, _ asyncCallBack: PluginResultCallBack?) -> String {
        
        let event = Event(args, action: asyncCallBack)
        if !event.name.isEmpty {
            bus[event.name] = event
        }
        return ""
    }
    
    func eventOff(_ args: Any, _ asyncCallBack: PluginResultCallBack?) -> String {
        
        let event = Event(args, action: asyncCallBack)
        if !event.name.isEmpty {
            
            if let eventOnBus = bus[event.name] {
                eventOnBus.action?(PluginResult.terminate(""))
            }
            
            bus[event.name] = nil
        }
        return ""
    }
    
    func eventSend(_ args: Any, _ asyncCallBack: PluginResultCallBack?) -> String {
        
        let event = Event(args, action: asyncCallBack)
        if let eventOnBus = bus[event.name] {
            //TODO: SEND logic
            let message = "发送时间  \(event.name): 参数 \(event.params)"
            eventOnBus.action?(PluginResult.continuous(message))
        }
        return ""
    }
}

fileprivate class Event {
    
    var name = ""
    var params = [String : Any]()
    var action:PluginResultCallBack? = nil
    
    fileprivate init(_ args: Any, action: PluginResultCallBack?) {
        
        guard let json = args as? String else {
            return
        }
        
        let jsonDic = json.seriailized()
        name = (jsonDic["eventName"] as? String) ?? ""
        params = (jsonDic["params"] as? [String : Any]) ?? [:]
        self.action = action
    }
    
}




