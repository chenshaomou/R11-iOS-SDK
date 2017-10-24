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
        let js = "_jswk='_jsbridge=';".appending(RWebView.INIT_SCRIPT)
        let script = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
        let scriptDomReady = WKUserScript(source: ";prompt('_jsinited');", injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(scriptDomReady)
        super.init(frame: frame, configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadRemoteURL(url: String, hash: String? = nil) {
        if let _url = URL(string: url){
            let request = URLRequest(url: _url)
            self.load(request)
        }else{
            //TODO: 读取出错界面
        }
        
    }
    
    func loadLocalURL(url: String, hash: String?) {
        let _url = URL(fileURLWithPath: url)
        self.loadFileURL(_url, allowingReadAccessTo: _url)
    }
    
    func callHandler(methodName:String,arguments:[String:Any]?,completionHandler:((Any?, Error?) -> Swift.Void)? = nil){
        if let _args = arguments?.objectToJSONString(){
            let script = "(window._jsf.\(methodName)||window.\(methodName)).call(window._jsf||window,\(_args))"
            self.evaluateJavaScript(script, completionHandler: completionHandler)
        }else{
            let script = "(window._jsf.\(methodName)||window.\(methodName)).call(window._jsf||window,{})"
            self.evaluateJavaScript(script, completionHandler: completionHandler)
        }
    }
}
