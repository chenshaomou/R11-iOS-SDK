//
//  DocumentModule.swift
//  Rainboweleven
//
//  Created by 吕仕滔 on 2018/9/12.
//  Copyright © 2018年 chenshaomou. All rights reserved.
//

import Foundation

public class DocumentModule {
    static let moduleName = "document"
    static let documentHandler = DocumentHandler()
    public func open() -> RWebkitPlugin{
        
        return RWebkitPlugin("open", { (args) -> Promise in
            // 判断参数
            guard let json = args as? String else {
                return Promise(Promise.emptyValue)
            }
            // 获取请求参数
            let jsonDic = json.seriailized()
            var url = (jsonDic["url"] as? String) ?? "";
            //            let method = (jsonDic["method"] as? String) ?? "get";
            
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
            
            // 回调promise
            let p = Promise()
            // 设置持续回调
            p.continuous = false
            let callback: (String)->() = { (result) in
                let resJson = result.seriailized()
                p.result = resJson.jsonString()
            }
            // 拼接文件沙盒路径
            url = NSHomeDirectory() + "/Documents/" + url
            print("拼接后的路径为：\(url)")
            // 调用文件处理工具弹出提示窗
            DocumentModule.documentHandler.openFile(urlString: url, callBack: callback)
            return p
        }, DocumentModule.moduleName)
    }
}
