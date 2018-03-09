//
//  RWKWebView.swift
//  Rainboweleven
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import UIKit
import WebKit

class RWKWebView: WKWebView ,RWebViewProtocol,WKUIDelegate,WKNavigationDelegate{
    
    weak open var theUIDelegate: WKUIDelegate?
    weak open var theNavigationDelegate : WKNavigationDelegate?
    //
    var groupExecuteLastTime:UInt64 = 0;
    
    var groupExecuteCache = "";
    
    var groupExecuteOnPending = false;
    
    var groupExecuteInterval:TimeInterval = 50.0
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        
        // 提前记住桥接对象与方法
        // 将插件转化为js内置对象
        let js = RWebView.initializedScript
        let script = WKUserScript(source: js,
                                  injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
        
        // 注册插件
        let buildInJsObj = RWebkitPluginsHub.shared.getJSBridgeBuiltInScript()
        let buildInJsObjScript = WKUserScript(source: buildInJsObj, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(buildInJsObjScript)
        
        super.init(frame: frame, configuration: configuration)
        self.uiDelegate = self
        
        EventBus.regiserEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadRemoteURL(url: String, hash: String? = nil) {
        
        if let _url = URL(string: url){
            let request = URLRequest(url: _url)
            self.load(request)
        }else{
            //TODO: 读取出错界面
        }
        
    }
    
    public func loadLocalURL(url: String, hash: String?) {
        let _url = URL(fileURLWithPath: url)
        self.loadFileURL(_url, allowingReadAccessTo: _url)
    }
    
    func callHandler(methodName:String,arguments:[String:Any]?,completionHandler:((Any?, Error?) -> Swift.Void)? = nil){
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let prefix = "WKWV"
        print("prompt = \(prompt)")
        
        guard prompt.hasPrefix(prefix) else {
            
            if let _theUIDelegate = self.theUIDelegate{
                _theUIDelegate.webView!(webView, runJavaScriptTextInputPanelWithPrompt: prompt, defaultText: defaultText, initiatedByFrame: frame, completionHandler: completionHandler)
            } else {
                completionHandler("")
            }
            
            return
        }
        
        print("defaultText = \(defaultText ?? "")")
        
        guard let jsonDict = defaultText?.seriailized() else { return }
        let args = jsonDict["params"] ?? []
        let module = jsonDict["module"] as! String
        let name = jsonDict["method"] as! String
        
        if let async : String = jsonDict["callbackName"] as? String{
            // 异步
            completionHandler("")
            let callbackResult = RWebkitPluginsHub.shared.runPlugin(name: name, module: module, args: args)
            let execJsCallBackScript = "window.jsBridge.callbacks.\(async)(\(callbackResult));"
            let clearJsCallBackScript =  "delete window.jsBridge.callbacks.\(async);"
            let js = "javascript: try { \(execJsCallBackScript)\(clearJsCallBackScript)} catch(e){};"
            self.evaluteJavaScriptSafey(webView, javaScript: js)
        }else{
            // 同步
            let result = RWebkitPluginsHub.shared.runPlugin(name: name, module: module, args: args)
            completionHandler(result)
            return
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if let theNavigationDelegate = self.theNavigationDelegate {
            theNavigationDelegate.webView!(webView, didFinish: navigation)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let theNavigationDelegate = self.theNavigationDelegate {
            theNavigationDelegate.webView!(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        }
    }
    
}

// MARK: - 确保线程安全地调用JS语句
extension RWKWebView {
    
    public func evaluteJavaScriptSafey(_ webView : WKWebView, javaScript : String) {
        
        objc_sync_enter(webView)
        let now:UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
        groupExecuteCache = "\(groupExecuteCache)\(javaScript)"
        var delay = 0.0
        if (now - groupExecuteLastTime) < 50, groupExecuteOnPending == false {
            delay = groupExecuteInterval
            groupExecuteOnPending = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay/1000.0 , execute: {[weak self] in
            
            guard let strongSelf = self else { return }
            
            objc_sync_enter(webView)
        
            if (strongSelf.groupExecuteCache.count != 0){
                
                webView.evaluateJavaScript(strongSelf.groupExecuteCache, completionHandler: { [weak webView] (_ , error) in
                    
                    if webView == nil {
                        return
                    }
                    
                    if let error = error {
                        //
                        print("JSBridge: run callback fail \(error.localizedDescription) ")
                    } else {
                        print("JSBridge: run callback js success ")
                    }
                    
                })
                
                strongSelf.groupExecuteOnPending = false
                strongSelf.groupExecuteCache = "";
                strongSelf.groupExecuteLastTime = UInt64(Date().timeIntervalSince1970 * 1000)
            }
            objc_sync_exit(webView)
        })
      
        objc_sync_exit(webView)
        
    }
    
}
