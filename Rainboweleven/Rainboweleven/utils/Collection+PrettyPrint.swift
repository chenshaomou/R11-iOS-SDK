//
//  Collection+PrettyPrint.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/10/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

extension Dictionary{
    
    internal func dictionaryToJSONString() -> String {
        if let jsonData = try? JSONSerialization .data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted){
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
                return jsonString
            }
        }
        return "{}"
    }
}

extension Array{
    
    internal func arrayToJSONString() -> String {
        if let jsonData = try? JSONSerialization .data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted){
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
                return jsonString
            }
        }
        return "[]"
    }
}

extension String{
    
    internal func stringToDictionary() -> Dictionary<String, Any>{
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
