//
//  Rainboweleven.swift
//  Rainboweleven
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import Foundation

public func load(_ url: String,hash: String = "",scheme: String = "default") -> RWebView{
    let rwebview = RWebView(frame: UIScreen.main.bounds)
    rwebview.loadURL(url: url, hash: hash)
    return rwebview
}

