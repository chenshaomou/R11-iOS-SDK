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
            let key = jsonDic["key"] as! String;
            let value = jsonDic["value"];
            UserDefaults.standard.set(value, forKey: key)
            return "";
        } , StoreModule.moduleName);
    }
    
    public func getValue() -> RWebkitPlugin {
        return RWebkitPlugin("get",{ (args) -> String in
            guard let json = args as? String else {
                return ""
            }
            let jsonDic = json.seriailized()
            let key = jsonDic["key"] as! String;
            if let value = UserDefaults.standard.string(forKey: key){
                return value
            }else{
                return "";
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
