//
//  AxiosModule.swift
//  Rainboweleven
//
//  Created by shaomou chen on 15/03/2018.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

// 网络模块插件
public class NetworkModule {
    
    // 模块名称
    static let moduleName = "network"
    // 下载工具类
    private let downloader = Downloader()
    
    // 请求方法 支持GET POST
    public func request() -> RWebkitPlugin{
        
        return RWebkitPlugin("request", { (args) -> Promise in
            // 判断参数
            guard let json = args as? String else {
                return Promise(Promise.emptyValue)
            }
            // 获取请求参数
            let jsonDic = json.seriailized()
            var url = (jsonDic["url"] as? String) ?? "";
            // url trimed
            url = url.replacingOccurrences(of: " ", with: "")
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
//                    print("Success \n")
//                    print("\(_string) \n")
                    p.result = "{\"config\":\(args),\"data\":\(_string)}"
                case .failure(let response):
//                    print("fail \n")
//                    print("\(response.error.localizedDescription) \n")
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
    
    // 下载文件
    public func download() -> RWebkitPlugin{
        //
        return RWebkitPlugin("download", { (args) -> Promise in
            // 判断参数
            guard let json = args as? String else {
                return Promise(Promise.emptyValue)
            }
            // 获取请求参数
            let jsonDic = json.seriailized()
            let url = (jsonDic["url"] as? String) ?? "";
            //
            let _header = jsonDic["headers"] as? [String: Any] ?? [String : Any]()
            //
            var header = [String : String]()
            //
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
            // 回调promise
            let p = Promise()
            // 设置持续回调
            let callback: (String)->() = { (result) in
                let resJson = result.seriailized()
                // 若非下载中，切已完成下载，则证明已经下载完成。设置持续回调为false
                let downloading = (resJson["downloading"] as? Bool) ?? false
                if (!downloading) {
                    print("download finish ....")
                    p.result = resJson.jsonString()
                } else {
                    print("push to downloading ...")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "onDownload"), object: nil, userInfo: ["result" : resJson])
                }
                print(resJson.jsonString())
            }
            //
            // 采用网络框架 发出下载文件请求
            self.downloader.download(url: url,callBack:callback)
            //
            return p
        }, NetworkModule.moduleName)
    }
}

