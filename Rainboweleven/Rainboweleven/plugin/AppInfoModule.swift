//
//  AppInfoModule.swift
//  Rainboweleven
//
//  Created by shaomou chen on 09/03/2018.
//  Copyright © 2018 chenshaomou. All rights reserved.
//

import Foundation

public class AppInfoModule{
    /**
     * 获取系统版本号插件
     */
    public func version() -> RWebkitPlugin{
        return RWebkitPlugin("version", { (_) -> String in
            //应用程序信息
            let infoDictionary = Bundle.main.infoDictionary!
            let majorVersion = infoDictionary["CFBundleShortVersionString"]//主程序版本号
            let minorVersion = infoDictionary["CFBundleVersion"]//版本号（内部标示）
            return "\(majorVersion ?? "noversioninfo").\(minorVersion ?? "nobuildinfo")"
        }, "appInfo");
    }
}
