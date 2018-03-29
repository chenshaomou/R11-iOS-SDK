//
//  AxiosModule.swift
//  Rainboweleven
//
//  Created by shaomou chen on 15/03/2018.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation
public class NetworkModule{
    
    static let moduleName = "network"
    public func request() -> RWebkitPlugin{
        
        return RWebkitPlugin("request", { (args) -> Promise in
            // 判断参数
            guard let json = args as? String else {
                return Promise(Promise.emptyValue)
            }
            // 获取请求参数
            let jsonDic = json.seriailized()
            let url = (jsonDic["url"] as? String) ?? "";
            let method = (jsonDic["method"] as? String) ?? "get";
            
            let _header = jsonDic["headers"] as? [String: Any] ?? [String : Any]()
            
            var header = [String : String]()
            
            _header.forEach({ (key, value) in
                if let _value = value as? String {
                    if "content-type" == key{
                        header["Content-Type"] = _value
                    }else{
                        header[key] = _value
                    }
                } else if let _value = value as? Bool {
                    header[key] = String(_value)
                } else if let _value = value as? Double {
                    header[key] = String(_value)
                }else if let _value = value as? Float {
                    header[key] = String(_value)
                }
            })

            var params:Any = [String:Any]()
            if let paramsAny = jsonDic["data"] {
                params = paramsAny
            }
            
            let contentType = header["Content-Type"] ?? "application/json"
            
            // 采用网络框架 发出请求
            let network = RBNetworking(baseURL: url)
            network.headerFields = header
            
            // 回调promise
            let p = Promise()
            
            let callback: (DataResult)->() = { (result) in
                print("==== response ==== \n")
                switch (result) {
                case .success(let response):
                    let _string = String(data: response.data, encoding: .utf8) ?? ""
                    p.result = "{\"config\":\(args),\"data\":\(_string)}"
                case .failure(let response):
                    p.result = ["error": ["response":["config":jsonDic],"message":response.error.localizedDescription]].jsonString()
                }
            }
            
            if method == "get" {
                network.get("", parameters: params, completion: callback)
            } else if method == "post" {
                if contentType.contains("json"){
                    
                    //Fix JSON Error in iOS: Invalid top-level type in JSON write
                    //顶级对象必须是 Dic / Array
                    guard params is [Any] || params is [String : Any] else {
                        p.result = ["error": ["response":["config":jsonDic],"message":"params 参数必须是对象或者数组"]].jsonString()
                        return p
                    }
                    
                    network.post("", parameterType: RBNetworking.ParameterType.json, parameters: params, completion: callback)
                }else if contentType.contains("form-data"){
                    network.post("", parameterType: RBNetworking.ParameterType.multipartFormData, parameters: params, completion: callback)
                }else if contentType.contains("x-www-form-urlencoded"){
                    network.post("", parameterType: RBNetworking.ParameterType.formURLEncoded, parameters: params, completion: callback)
                }else{
                    network.post("", parameterType: RBNetworking.ParameterType.none, parameters: params, completion: callback)
                }
            }
            //
            return p
        }, NetworkModule.moduleName)
    }
}

