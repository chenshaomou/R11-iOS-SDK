//
//  RUIWebView.swift
//  Rainboweleven
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import UIKit

internal class RUIWebView: UIWebView ,RWebViewProtocol {
    
    var groupExecuteLastTime:UInt64 = 0;
    
    var groupExecuteCache = "";
    
    var groupExecuteOnPending = false;
    
    var domLoadFinish =  false;
    
    var groupExecuteInterval:TimeInterval = 50.0
    
    let id = UUID.init().uuidString
    
    func loadLocalURL(url: String, hash: String?) {
        
        //注册事件监听
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(notification:)), name: nil, object: nil)
        
        let fileUrl = URL(fileURLWithPath: url)
        let request = URLRequest(url: fileUrl)
        self.loadRequest(request)
    }
    
    func loadRemoteURL(url: String, hash: String? = nil) {
        
        //注册事件监听
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(notification:)), name: nil, object: nil)
        
        if let url = URL(string: url){
            let request = URLRequest(url: url)
            self.loadRequest(request)
        } else {
            //TODO: 读取出错界面
        }
    }
    
    func evaluteJavaScriptSafey(javaScript: String, theCompletionHandler: @escaping ((Any?, Error?) -> Void)) {
        
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
        case NSNotification.Name.UIApplicationDidBecomeActive:
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
