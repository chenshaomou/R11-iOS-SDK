//
//  ApplicationEvent.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/12/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

public class ApplicationEvent {}

extension ApplicationEvent {
    
    public class OnResume : DefaultEvent, EventProtocol {
        
        public static var shared: EventProtocol = OnResume()
        
        public var jsEventMapping: String {
            return "onResume"
        }
        
        public override init() {
            super.init()
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: nil, queue: OperationQueue.main) {[weak self] (notify) in
                
                self?.nativeObservers.forEach({ (_, observer) in
                    observer(notify)
                })
                
                self?.jsObservers.forEach({ (_, observer) in
                    observer.action?(PluginResult.success(""))
                })
            }
        }
        
        public func onJSSend(args: Any, jsEvent: JSEvent) {
            
        }
        
    }
    
}
