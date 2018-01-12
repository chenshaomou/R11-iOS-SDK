//
//  AppInfoVersionPlugin.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/12/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

public class AppInfoPlugin : RWebkitCustomPlugin {
    
    public static var shared: RWebkitCustomPlugin = AppInfoPlugin()
    
    public var moduleName: String? {
        return "appInfo"
    }
    
    public var actionMapping: [String : NativeAction]? {
        return ["version" : versionAction]
    }
    
    public var customFuncMapping: [String : (String, NativeAction)]? {
        return nil
    }
    
    // 版本插件
    func versionAction(_ callbackName: String?, _ args: Any, _ asyncCallBack: NativeCallback?) -> String {
        return "1.0.1"
    }
    
}
