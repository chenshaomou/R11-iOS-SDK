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
        return RWebkitPlugin("set",{ (args) -> String in
            guard let json = args as? String else {
                return ""
            }
            let jsonDic = json.seriailized()
            if let _frist = jsonDic.first{
                UserDefaults.standard.set(_frist.value, forKey: _frist.key)
                return jsonDic.jsonString();
            }else{
                return RWebkitPlugin.throwError(reason: "no 'key' parameter")
            }
        } , StoreModule.moduleName);
    }
    
    public func getValue() -> RWebkitPlugin {
        return RWebkitPlugin("get",{ (args) -> String in
            if let key = args as? String{
                if let value = UserDefaults.standard.string(forKey: key){
                    return value
                }else{
                    return "";
                }
            } else {
                return RWebkitPlugin.throwError(reason: "parameter must be a string")
            }
        } , StoreModule.moduleName);
    }
    
    public func removeValue() -> RWebkitPlugin {
        return RWebkitPlugin("remove",{ (args) -> String in
            guard let json = args as? String else {
                return ""
            }
            //TODO: 判断没有key值或者key值不存在的情况
            let jsonDic = json.seriailized()
            let key = jsonDic["key"] as! String;
            if let value = UserDefaults.standard.string(forKey: key){
                UserDefaults.standard.removeObject(forKey: key)
                return value
            }else{
                return ""
            }
        } , StoreModule.moduleName);
    }
}
