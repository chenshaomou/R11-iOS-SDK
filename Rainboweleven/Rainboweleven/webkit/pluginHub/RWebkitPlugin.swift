//
//  RWebPlugin.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/11/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

// 插件结果枚举
public enum PluginResult {
    // 成功并返回JS语句
    case success(String)
    // 失败
    case failure(Error)
}

// 原生插件函数类型
// * 若不实现该方法，则插件无效
// callbackName : js回调函数引用
// args : js传入的参数
// asyncCallBack : 原生回调
public typealias Action = (_ args: Any) -> String

public class RWebkitPlugin {
    
    //插件所属模块
    public let module : String
    //插件名称
    public let name : String
    //插件功能
    public let action : Action
    
    public init(_ name:String, _ action:@escaping Action, _ module:String = "userDefault") {
        self.name = name
        self.action = action
        self.module  = module
    }
    
    public func getKey() -> String {
        return "\(module).\(name)"
    }
    
    public func reginsterPluginScript() -> String {
        return NSString(format:"window.jsBridge.%@=window.jsBridge.%@||{};Object.assign(window.jsBridge.%@,{%@:function(a,b){if(0===arguments.length)return window.jsBridge.call('%@','%@',{});if(1===arguments.length)return window.jsBridge.call('%@','%@',a);2===arguments.length&&window.jsBridge.call('%@','%@',a,b)}});",self.module,self.module,self.module,self.name,self.module, self.name,self.module, self.name,self.module, self.name) as String
    }
    
    static public func throwError(reason:String?) -> String {
        if let _reason = reason{
            return ["exception":_reason].jsonString()
        }else{
            return ["exception":"invoke plugin error"].jsonString()
        }
    }
}

// MARK: - URL Encode
extension String {
    // 对返回参数进行 URL Encode 防止中文乱码
    fileprivate var encodingValue : String? {
        if let res =  self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return "decodeURIComponent('\(res)')"
        }
        return ""
    }
}
