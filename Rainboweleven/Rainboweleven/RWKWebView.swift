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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    weak open var ruiDelegate: WKUIDelegate?
    
    //
    var g_r_last_call_time:UInt64 = 0;
    var g_r_js_cache = "";
    var g_r_have_pending = false;
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        let js = "_jswk='_jsbridge=';".appending(RWebView.INIT_SCRIPT)
        let script = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
        let scriptDomReady = WKUserScript(source: ";prompt('_jsinited');", injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(scriptDomReady)
        super.init(frame: frame, configuration: configuration)
        self.uiDelegate = self
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
        if let _args = arguments?.dictionaryToJSONString(){
            let script = "(window._jsf.\(methodName)||window.\(methodName)).call(window._jsf||window,\(_args))"
            self.evaluateJavaScript(script, completionHandler: completionHandler)
        }else{
            let script = "(window._jsf.\(methodName)||window.\(methodName)).call(window._jsf||window,{})"
            self.evaluateJavaScript(script, completionHandler: completionHandler)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let _prefix = "_jsbridge="
        let _jsinited = "_jsinited"
        if prompt.hasPrefix(_jsinited){
            //TODO: jsbridge 完成初始化
            completionHandler("")
        }else if prompt.hasPrefix(_prefix){
            let method = String(prompt.suffix(from: _prefix.endIndex))
            guard let _dic = defaultText?.stringToDictionary() else { return }
            if let _jscallback = _dic["_jscbstub"]{
                //异步调用
                //马上返回 TODO:// 可以返回啥
                completionHandler("")
                let _value = RWebkitPluginsHub.shared.runPlugin(name: method, args: _dic).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let _del = "delete window.\(_jscallback)"
                let _js = "try {\(_jscallback)(decodeURIComponent(\"\(_value ?? "")\"));\(_del); } catch(e){};"
                objc_sync_enter(webView)
                let _now:UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
                g_r_js_cache = "\(g_r_js_cache)\(_js)"
                var _delay = 0.0
                if(_now - g_r_last_call_time < 50 && g_r_have_pending == false){
                    _delay = 50.0
                    g_r_have_pending = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + _delay/1000.0 , execute: {[unowned self] in
                    objc_sync_enter(webView)
                    if (self.g_r_js_cache.count != 0){
                        //TODO:执行完成可以弄些啥
                        webView.evaluateJavaScript(self.g_r_js_cache, completionHandler: nil)
                        self.g_r_have_pending = false
                        self.g_r_js_cache = "";
                        self.g_r_last_call_time = UInt64(Date().timeIntervalSince1970 * 1000)
                    }
                    objc_sync_exit(webView)
                })
                objc_sync_exit(webView)
            }else{
                //同步调用
                let result = RWebkitPluginsHub.shared.runPlugin(name: method, args: _dic)
                //TODO: 处理报错
                completionHandler(result)
            }
        }else if let _ruiDelegate = self.ruiDelegate{
            _ruiDelegate.webView!(webView, runJavaScriptTextInputPanelWithPrompt: prompt, defaultText: defaultText, initiatedByFrame: frame, completionHandler: completionHandler)
        }else{
            //TODO: 普通的 js prompt
        }
    }
    
}
