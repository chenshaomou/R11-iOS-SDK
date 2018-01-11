//
//  AppInfoVersionPlugin.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 1/12/18.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

public class AppInfoPlugin : RWebkitCustomPlugin {
    
    public static var shared: RWebkitCustomPlugin {
        return AppInfoPlugin()
    }
    
    public var moduleName: String? {
        return "appInfo"
    }
    
    public var actionMapping: [String : PluginAction]? {
        return ["version" : versionAction]
    }
    
    public var customFuncMapping: [String : String]? {
        return nil
    }
    
    // 版本插件
    func versionAction(_ args: Any, _ asyncCallBack: PluginResultCallBack?) -> String {
        return "1.0.1"
    }
    
}
