//
//  Rainboweleven.swift
//  Rainboweleven
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import Foundation

extension Dictionary{
    
    func dictionaryToJSONString() -> String {
        if let jsonData = try? JSONSerialization .data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted){
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
                return jsonString
            }
        }
        return "{}"
    }
}

extension Array{
    
    func arrayToJSONString() -> String {
        if let jsonData = try? JSONSerialization .data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted){
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
                return jsonString
            }
        }
        return "[]"
    }
}

extension String{
    func stringToDictionary() -> Dictionary<String, Any>{
        if let _data = self.data(using: String.Encoding.utf8){
            if let _json = try? JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments){
                if let _dic = _json as? Dictionary<String, Any>{
                    return _dic
                }
            }
        }
        return Dictionary();
    }
}

public func loadRemoteURL(_ url: String,hash: String = "",scheme: String = "defaultRemote") -> RWebView{
    let rwebview = RWebView(frame: UIScreen.main.bounds)
    rwebview.loadRemoteURL(url: url)
    return rwebview
}

public func loadLocalURL(_ url: String,hash: String = "",scheme: String = "defaultRemote") -> RWebView{
    let rwebview = RWebView(frame: UIScreen.main.bounds)
    rwebview.loadLocalURL(url: url)
    return rwebview
}

