//
//  RUIWebView.swift
//  Rainboweleven
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import UIKit
import JavaScriptCore

internal class RUIWebView: UIWebView ,RWebViewProtocol {
    
    var groupExecuteLastTime:UInt64 = 0;
    
    var groupExecuteCache = "";
    
    var groupExecuteOnPending = false;
    
    var domLoadFinish =  false;
    
    var groupExecuteInterval:TimeInterval = 50.0
    
    let id = UUID.init().uuidString
    
    let bridge = JSBridge()
    
    var ctx: JSContext?
    
    var jsSource = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        //注册事件监听
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(notification:)), name: nil, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadLocalURL(url: String, hash: String?) {
        let fileUrl = URL(fileURLWithPath: url)
        let request = URLRequest(url: fileUrl)
        self.loadRequest(request)
        do {
          self.jsSource = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8)
        } catch {
            // ...
        }
    }
    
    func loadRemoteURL(url: String, hash: String? = nil) {
        if let url = URL(string: url){
            let request = URLRequest(url: url)
            self.loadRequest(request)
        } else {
            //TODO: 读取出错界面
        }
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
                strongSelf.stringByEvaluatingJavaScript(from: exec)
                strongSelf.groupExecuteOnPending = false
                strongSelf.groupExecuteCache = "";
                strongSelf.groupExecuteLastTime = UInt64(Date().timeIntervalSince1970 * 1000)
            }
            objc_sync_exit(strongSelf.id)
        })
    }
    
    func callHandler(method:String,arguments:[String:Any]?,completionHandler:((Any?, Error?) -> Swift.Void)? = nil){
    }
    
    //收到通知，向js发送事件
    @objc fileprivate func didReceiveNotification(notification:Notification){
        // 防止js事件发送到原生后又通过原生传播到js
        if let userInfo = notification.userInfo, let _webViewId = userInfo["webviewid"] as? String, _webViewId == self.id {
            return
        }
        
        switch notification.name {
        case UIApplication.didBecomeActiveNotification:
            //
            let script = String.init(format:RWebView.jsEventTigger, "onResume", "")
            self.evaluteJavaScriptSafey(javaScript: script, theCompletionHandler: { (any, error) in })
        case NSNotification.Name("domLoadFinish"):
            // 推动缓存马上执行
            self.domLoadFinish = true;
            self.evaluteJavaScriptSafey(javaScript: "", theCompletionHandler: { (any, error) in })
        default:
            //
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

//mark: - 桥接原生对象
@objc protocol JSBridgeProtocol : JSExport {
    
    func send(_ name: String, _ args: [String: AnyObject])
    
    func test() -> String
    
    func callAsync(_ reqStr: String)
    
    func callSync(_ reqStr: String) -> String
    
}

@objc class JSBridge : NSObject, JSBridgeProtocol {
    
    weak var wv: RUIWebView?
    weak var jsContext: JSContext?
    
    // 发送通知给原生事件
    func send(_ name: String, _ args: [String: AnyObject]) {
        //
        NotificationCenter.default.post(name: NSNotification.Name(name), object: nil, userInfo: args)
    }
    // 测试方法 - 同步
    func test() -> String {
        //
        return "Hello World"
    }
    // 调用同步方法
    func callAsync(_ reqStr: String) {
        //
        let _ = innerCall(reqStr, isSync: false)
    }
    
    // 调用异步方法
    func callSync(_ reqStr: String) -> String {
        //
        return innerCall(reqStr, isSync: true)
    }
    
    func innerCall(_ reqStr: String, isSync: Bool) -> String {
        
        let jsonDict = reqStr.seriailized()
        let args = jsonDict["params"] ?? []
        let module = jsonDict["module"] as! String
        let name = jsonDict["method"] as! String
        
        if let async : String = jsonDict["callbackName"] as? String{
            // 异步
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
                strongSelf.wv?.evaluteJavaScriptSafey(javaScript: js, theCompletionHandler: { (_, _) in
                    //
                })
            })
            
        } else {
            // 同步
            let p = RWebkitPluginsHub.shared.runPlugin(name: name, module: module, args: args)
            if let res = p.result {
                return res
            }
        }
        return ""
    }
}

extension RUIWebView : UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.domLoadFinish = true
        
        if let _ = self.ctx { return }
        
        if let ctx = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            self.ctx = ctx
            self.bridge.jsContext = ctx
            self.bridge.wv = self
            self.ctx?.setObject(self.bridge, forKeyedSubscript: "jsBridgeUIWV" as NSCopying & NSObjectProtocol)
            self.ctx?.evaluateScript(self.jsSource)
            self.ctx?.exceptionHandler = { (context, exception) in
                if let e = exception {
                    print("exception = \(e)")
                }
            }
        }
        
        let js = RWebView.initializedScriptForUIWV + RWebkitPluginsHub.shared.getJSBridgeBuiltInScript()
        DispatchQueue.main.async {[weak self] in
            self?.stringByEvaluatingJavaScript(from: js)
        }
    }
    
    func test() {
        print("test ...")
    }
}
