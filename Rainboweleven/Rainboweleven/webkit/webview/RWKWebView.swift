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
    
    var domLoadFinish =  false;
    
    var groupExecuteInterval:TimeInterval = 50.0
    
    let id = UUID.init().uuidString
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        
        // 提前记住桥接对象与方法
        // 将插件转化为js内置对象
        let js = RWebView.initializedScript
        let script = WKUserScript(source: js,
                                  injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
        
//         注册插件
        let buildInJsObj = RWebkitPluginsHub.shared.getJSBridgeBuiltInScript()
        let buildInJsObjScript = WKUserScript(source: buildInJsObj, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(buildInJsObjScript)

        // 加上webview的id
        let idScript = WKUserScript(source: String.init(format:RWebView.jsBridgeId, id), injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(idScript)
        
        super.init(frame: frame, configuration: configuration)
        self.uiDelegate = self
        self.navigationDelegate = self
        
        //注册事件监听
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(notification:)), name: nil, object: nil)
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
    
    // MARK: - 确保线程安全地调用JS语句
    public func evaluteJavaScriptSafey(javaScript: String, theCompletionHandler: @escaping ((Any?, Error?) -> Void)) {
        
        let now:UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
        groupExecuteCache = "\(groupExecuteCache)\(javaScript)"
        
        //webview 的 jsbridge 还没有初始化完成 不执行
        if (domLoadFinish == false){
            return
        }
        
        var delay = 0.0
        if (now - groupExecuteLastTime) < 50, groupExecuteOnPending == false{
            delay = groupExecuteInterval
            groupExecuteOnPending = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay/1000.0 , execute: {[weak self] in
            
            guard let strongSelf = self else { return }
            
            objc_sync_enter(strongSelf.id)
            
            if (strongSelf.groupExecuteCache.count != 0){
                
                let exec = strongSelf.groupExecuteCache
                strongSelf.evaluateJavaScript(exec, completionHandler: { [weak strongSelf] (any , error) in
                    
                    guard let _ = strongSelf else { return }
                    
                    if let error = error {
                        print("JSBridge: run callback fail \(error.localizedDescription) ; execute cache = \(exec)")
                    } else {
                        // print("JSBridge: run callback js success ; execute cache = \(exec)")
                    }
                    
                    if theCompletionHandler != nil {
                        theCompletionHandler(any,error)
                    }
                })
                
                strongSelf.groupExecuteOnPending = false
                strongSelf.groupExecuteCache = "";
                strongSelf.groupExecuteLastTime = UInt64(Date().timeIntervalSince1970 * 1000)
            }
            objc_sync_exit(strongSelf.id)
        })
    }
    
    func callHandler(method:String,arguments:[String:Any]?,completionHandler:((Any?, Error?) -> Swift.Void)? = nil){
        let argsStr = arguments?.jsonString() ?? ""
        let js = "window.jsBridge.func.\(method)(JSON.stringify(\(argsStr)))"
        self.evaluteJavaScriptSafey(javaScript: js, theCompletionHandler: completionHandler!)
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
            let p  = RWebkitPluginsHub.shared.runPlugin(name: name, module: module, args: args)
            p.then(callback: { [weak self](data) in
                
                guard let strongSelf = self else { return }
                guard let callbackResult = data else { return }
                
                var execJsCallBackScript = ""
                
                if (callbackResult.starts(with: "{") || callbackResult.starts(with: "[")){
                    //返回结果是对象或者数组 都转成字符串 统一输出 swift 实在垃圾到不想用
                    execJsCallBackScript = String(format:"window.jsBridge.callbacks.%@(JSON.stringify(%@));",async,callbackResult)
                }else{
                    execJsCallBackScript = "window.jsBridge.callbacks.\(async)('\(callbackResult)');"
                }
                var clearJsCallBackScript =  "delete window.jsBridge.callbacks.\(async);"
                if (p.continuous) {
                    clearJsCallBackScript = ""
                }
                // let js = "javascript: try { \(execJsCallBackScript)\(clearJsCallBackScript)} catch(e){};"
                let js = "try { \(execJsCallBackScript)\(clearJsCallBackScript)} catch(e){};"
                strongSelf.evaluteJavaScriptSafey(javaScript: js, theCompletionHandler: { (any, error) in })
            })
        }else{
            // 同步
            let p = RWebkitPluginsHub.shared.runPlugin(name: name, module: module, args: args)
            p.then(callback: { (result) in
                completionHandler(result)
            })
            
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

// MARK: - 向js广播消息处理
extension RWKWebView{
    
    //收到通知，向js发送事件
    @objc fileprivate func didReceiveNotification(notification:Notification){
        // 防止js事件发送到原生后又通过原生传播到js
        if let userInfo = notification.userInfo, let _webViewId = userInfo["webviewid"] as? String, _webViewId == self.id {
            return
        }
        
        switch notification.name {
        case UIApplication.didBecomeActiveNotification:
            let script = String.init(format:RWebView.jsEventTigger, "onResume", "")
            self.evaluteJavaScriptSafey(javaScript: script, theCompletionHandler: { (any, error) in })
        case NSNotification.Name("domLoadFinish"):
            self.domLoadFinish = true;
            // 推动缓存马上执行
            self.evaluteJavaScriptSafey(javaScript: "", theCompletionHandler: { (any, error) in })
        default:
            var param: String = ""
            if let userInfo:[String: NSObject] = notification.userInfo as? [String: NSObject]{
                if JSONSerialization.isValidJSONObject(userInfo){
                    let dictData = try? JSONSerialization.data(withJSONObject: userInfo, options: [])
                    param = String(data: dictData!, encoding: String.Encoding.utf8)!
                }
            }
            let script = String.init(format:RWebView.jsEventTigger, notification.name.rawValue, param)
            self.evaluteJavaScriptSafey(javaScript: script, theCompletionHandler: { (any, error) in })
            break
        }
    }
}
