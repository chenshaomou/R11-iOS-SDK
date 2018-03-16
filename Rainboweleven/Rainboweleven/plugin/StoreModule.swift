//
//  StoreModule.swift
//  Rainboweleven
//
//  Created by shaomou chen on 14/03/2018.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

public class StoreModule{
    
    static let moduleName = "store"
    
    public func setValue() -> RWebkitPlugin {
        return RWebkitPlugin("set",{ (args) -> Promise in
            guard let json = args as? String else {
                return Promise()
            }
            let jsonDic = json.seriailized()
            if let _frist = jsonDic.first{
                UserDefaults.standard.set(_frist.value, forKey: _frist.key)
//                return jsonDic.jsonString();
                return Promise()
            }else{
//                return RWebkitPlugin.throwError(reason: "no 'key' parameter")
                return Promise()
            }
        } , StoreModule.moduleName);
    }
    
    public func getValue() -> RWebkitPlugin {
        return RWebkitPlugin("get",{ (args) -> Promise in
            if let key = args as? String{
                if let value = UserDefaults.standard.string(forKey: key){
//                    return value
                    return Promise()
                }else{
//                    return "";
                    return Promise()
                }
            } else {
//                return RWebkitPlugin.throwError(reason: "parameter must be a string")
                return Promise()
            }
        } , StoreModule.moduleName);
    }
    
    public func removeValue() -> RWebkitPlugin {
        return RWebkitPlugin("remove",{ (args) -> Promise in
            if let key = args as? String{
                if let value = UserDefaults.standard.string(forKey: key){
                    UserDefaults.standard.removeObject(forKey: key)
//                    return value
                    return Promise()
                }else{
//                    return "";
                    return Promise()
                }
            } else {
//                return RWebkitPlugin.throwError(reason: "parameter must be a string")
                return Promise()
            }
        } , StoreModule.moduleName);
    }
}
