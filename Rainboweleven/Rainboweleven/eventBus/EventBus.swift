//
//  EventBus.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/12/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

public class EventBus {
    
    public static let shared = EventBus()
    
    internal var context = [String : EventProtocol]()
    
    public class func wrap(From jsEvent: JSEvent) -> EventProtocol? {
        return shared.context[jsEvent.name]
    }
    
    public class func regiserEvent() {
        ApplicationEvent.OnResume.register()
        DomLoadFinishEvent.register()
    }
    
}
