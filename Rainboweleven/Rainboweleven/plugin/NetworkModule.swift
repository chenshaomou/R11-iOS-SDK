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
            let header = (jsonDic["headers"] as? [String:String]) ?? [String:String]()
            let params = (jsonDic["data"] as? [String:Any]) ?? [String:Any]()
            // let type = (jsonDic["type"] as? String) ?? "raw";
            
            // 采用网络框架 发出请求
            let network = RBNetworking(baseURL: url)
            network.headerFields = header
            
            // 回调promise
            let p = Promise()
            
            let callback: (JSONResult)->() = { (result) in
                print("==== response ==== \n")
                print("\(result.toJSONString())")
                switch (result) {
                case .success(_):
                    p.result = ["config":jsonDic,"data":result.toJSONString().seriailized()].jsonString()
                case .failure(let response):
                    p.result = ["error": ["response":["config":jsonDic],"message":response.error.localizedDescription]].jsonString()
                }
            }
            
            if method == "get" {
              network.get("", parameters: params, completion: callback)
            } else if method == "post" {
              network.post("", parameters: params, completion: callback)
            }
            //
            return p
        }, NetworkModule.moduleName)
    }
}

