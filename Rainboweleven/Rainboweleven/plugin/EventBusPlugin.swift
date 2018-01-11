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
        return nil
    }
    
    public var customFuncMapping: [String : String]? {
        return nil 
    }
}


