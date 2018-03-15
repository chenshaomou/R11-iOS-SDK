//
//  EventsModule.swift
//  Rainboweleven
//
//  Created by shaomou chen on 13/03/2018.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

open class EventsModule{
    
    static let moduleName = "events"
    
    /**
     * 接受到js发送来的事件
     */
    public func EventTigger() -> RWebkitPlugin{
        return RWebkitPlugin("send", { (args) -> String in
            guard let json = args as? String else {
                return ""
            }
            let jsonDic = json.seriailized()
            let name = (jsonDic["eventName"] as? String) ?? ""
            let params = (jsonDic["params"] as? [String : Any]) ?? [:]
            NotificationCenter.default.post(name: NSNotification.Name(name), object: nil, userInfo: params)
            return ""
        }, EventsModule.moduleName)
    }
}
