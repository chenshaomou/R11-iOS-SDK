//
//  RWebkitPluginsHub.swift
//  Rainboweleven
//
//  Created by chenshaomou on 24/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import Foundation

typealias PluginAction = (_ args:[String:Any]) -> String

class RWebkitPlugin {
    let name : String
    let action : PluginAction
    
    init(_ n:String,_ a:@escaping PluginAction) {
        self.name = n
        self.action = a
    }

}

//插件管理器，单例实现
class RWebkitPluginsHub {
    
    static let shared = RWebkitPluginsHub.init()
    var plugins = [String : RWebkitPlugin]()
    
    private init(){
        //添加存储插件
        self.addPlugin(name: "getValue") { (args) -> String in
            return "Hello,\(args.dictionaryToJSONString())"
        }
    }
    
    func addPlugin(name:String,action:@escaping PluginAction ) {
        plugins[name] = RWebkitPlugin(name,action)
    }
    
    func runPlugin(name:String,args:[String:Any]) -> String {
        //TODO: 不存在，报错
        guard let _plugin = plugins[name] else { return ""}
        return _plugin.action(args)
    }
    
    
}
