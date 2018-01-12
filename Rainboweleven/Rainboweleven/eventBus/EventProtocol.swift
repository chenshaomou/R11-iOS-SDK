//
//  Event.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/12/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

public typealias EventObsever = (_ notify: Notification) -> Void

public protocol EventProtocol {
    
    static var shared : EventProtocol { get }
    
    var jsObservers : [String: JSEvent] { get }
    
    var nativeObservers : [String: EventObsever] { get }
    
    var jsEventMapping : String { get }
    
    // -- For Native ---
    
    //
    func addObserver(name: String, observer : @escaping EventObsever)
    //
    func removeObserver(name :String)
    
    // ---- For Js -----
    //
    func addJSObserver(jsEvent: JSEvent)
    
    //
    func removeJSObserver(jsEvent: JSEvent)
    
    //
    func onJSSend(args : Any, jsEvent : JSEvent)
    
    //
    static func register()
    
}

public class DefaultEvent {
    
    public var jsObservers : [String: JSEvent] = [:]
    
    public var nativeObservers : [String: EventObsever] = [:]
    
    public func addObserver(name: String, observer : @escaping EventObsever) {
        nativeObservers[name] = observer
    }
    
    public func removeObserver(name :String) {
        nativeObservers[name] = nil
    }
    
    public func addJSObserver(jsEvent: JSEvent) {
        jsObservers[jsEvent.name] = jsEvent
    }
    
    public func removeJSObserver(jsEvent: JSEvent) {
        jsObservers[jsEvent.name] = nil
    }
    
}

extension EventProtocol {
    
    public static func register() {
        EventBus.shared.context[self.shared.jsEventMapping] = self.shared
    }
}
