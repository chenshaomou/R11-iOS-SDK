//
//  AxiosModule.swift
//  Rainboweleven
//
//  Created by shaomou chen on 15/03/2018.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation
import Alamofire

public class NetworkModule{
    
    static let moduleName = "network"
    
    public func request() -> RWebkitPlugin{
        return RWebkitPlugin("request", { (args) -> Promise in
            guard let json = args as? String else {
                return Promise(Promise.emptyValue)
            }
            
            let jsonDic = json.seriailized()
            let url = (jsonDic["url"] as? String) ?? "";
            let method = (jsonDic["method"] as? String) ?? "get";
            var _method = HTTPMethod.get
            
            switch method {
            case "get" :
                _method = HTTPMethod.get
            case "post" :
                _method = HTTPMethod.post
            default:
                _method = HTTPMethod.get
            }
            
            let header = (jsonDic["header"] as? [String:String]) ?? [String:String]();
            let data = (jsonDic["data"] as? [String:Any]) ?? [String:Any]();
//            let type = (jsonDic["type"] as? String) ?? "raw";
            
            let p = Promise()
            
            Alamofire.request(url, method: _method, parameters: data, encoding: URLEncoding.default, headers: header).responseString(completionHandler: { (data) in
                if(data.result.isSuccess){
                    let _value = data.result.value
                    p.result = _value
                }else{
                    if let error = data.result.error{
                        //网络错误
                        p.result = ["error":error.localizedDescription].jsonString()
                    }else{
                        p.result = ["error":"net work error"].jsonString()
                    }
                }
            })
            
            return p
            
        }, NetworkModule.moduleName)
    }
}
