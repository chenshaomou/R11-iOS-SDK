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
    
    public func EventTigger() -> RWebkitPlugin{
        return RWebkitPlugin("get", { (args) -> Promise in
            guard let json = args as? String else {
                return Promise(Promise.emptyValue)
            }
            
            let p = Promise()
            
            Alamofire.request("").responseString(completionHandler: { (data) in
                p.result = data.result.value
            })
            
            return p
            
        }, NetworkModule.moduleName)
    }
}
