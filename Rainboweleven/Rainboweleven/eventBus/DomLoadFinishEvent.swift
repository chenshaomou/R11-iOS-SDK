//
//  DomLoadFinishEvent.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/12/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

public class DomLoadFinishEvent : DefaultEvent, EventProtocol {
    
    public static var shared: EventProtocol = DomLoadFinishEvent()
    
    public var jsEventMapping: String {
        return "domLoadFinishEvent"
    }
    
    override init() {
        super.init()
    }
    
    public func onJSSend(args: Any, jsEvent: JSEvent) {
        print("JS DomLoadFinishEvent args = \(args)")
    }
    
}
