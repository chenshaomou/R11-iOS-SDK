//
//  RWKWebView.swift
//  Rainboweleven
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import UIKit
import WebKit

class RWKWebView: WKWebView ,RWebViewProtocol{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        let js = "_dswk='_dsbridge=';".appending(RWebView.INIT_SCRIPT)
        let script = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
        let scriptDomReady = WKUserScript(source: ";prompt('_dsinited');", injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(scriptDomReady)
        super.init(frame: frame, configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadURL(url: String, hash: String) {
        if let url = URL(string: url){
            let request = URLRequest(url: url)
            self.load(request)
        }else{
            //TODO: 读取出错界面
        }
    }
}
