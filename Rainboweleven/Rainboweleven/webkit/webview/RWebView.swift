//
//  RWebView.swift
//  Rainboweleven
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import UIKit
import WebKit

@objc public protocol RWebViewProtocol: NSObjectProtocol {
    
    @objc func loadRemoteURL(url: String,hash: String?) -> Void
    
    @objc func loadLocalURL(url: String,hash: String?) -> Void
    
    @objc var scrollView: UIScrollView { get }
    
    @objc func evaluteJavaScriptSafey(javaScript : String, theCompletionHandler: @escaping ((Any?, Error?) -> Swift.Void))
    
    @objc func callHandler(method:String,arguments:[String:Any]?,completionHandler:((Any?, Error?) -> Swift.Void)?)
    
    @objc func openNotification()
    
    @objc func offNotification()
}

public enum RWebKitType{
    case UIWebView
    case WKWebView
}

@objc public class RWebView: UIView,RWebViewProtocol {
 
    internal var wv:RWebViewProtocol!
    @objc public var scrollView: UIScrollView{
        get{
            return wv.scrollView
        }
    }
    // 可指定WebKit类型
    public var customWebKit: RWebKitType?
    @objc public var uiwebView: UIWebView? {
        get {
            return wv as? UIWebView
        }
    }
    @objc public var wkwebView: WKWebView? {
        get {
            return wv as? WKWebView
        }
    }
    
    @objc weak public var theUIDelegate: WKUIDelegate? {
        didSet {
            if let rwv = wv as? RWKWebView {
                rwv.theUIDelegate = theUIDelegate
            }
        }
    }
    
    @objc weak public var theNavigationDelegate : WKNavigationDelegate? {
        didSet {
            if let rwv = wv as? RWKWebView {
                rwv.theNavigationDelegate = theNavigationDelegate
            }
        }
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpWebView()
    }
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpWebView()
    }
    
    public init(frame: CGRect, type: RWebKitType) {
        super.init(frame: frame)
        self.customWebKit = type
        setUpWebView()
    }
    
    @objc public init(frame: CGRect, type: NSString) {
        super.init(frame: frame)
        if type.isEqual("WKWebView") {
            self.customWebKit = .WKWebView
        } else {
            self.customWebKit = .UIWebView
        }
        setUpWebView()
    }
    
    fileprivate func setUpWebView() {
        
        if let type = self.customWebKit {
            
            switch type {
            case .UIWebView:
                wv = RUIWebView(frame: frame)
                break
            case .WKWebView:
                wv = RWKWebView(frame: frame)
                wv.scrollView.bounces = true
                break
            }
            
        } else {
            //如果是iOS 8 以上系统就用 WKWebview 否用用 UIWebview
            if((UIDevice.current.systemVersion as NSString).floatValue >= 8.0){
                wv = RWKWebView(frame: frame)
                wv.scrollView.bounces = true
            }else{
                wv = RUIWebView(frame: frame)
            }
        }
        
        let uv = wv as! UIView
        self.addSubview(uv)
    }
    
    public var webView: RWebViewProtocol{
        get{
            return wv
        }
    }
    
    @objc public func loadRemoteURL(url: String, hash: String? = nil) {
        wv.loadRemoteURL(url:url, hash: hash)
    }
    
    @objc public func loadLocalURL(url: String, hash: String? = nil) {
        wv.loadLocalURL(url:url, hash: hash)
    }
    
    @objc public func evaluteJavaScriptSafey(javaScript: String, theCompletionHandler: @escaping ((Any?, Error?) -> Void)) {
        wv.evaluteJavaScriptSafey(javaScript: javaScript, theCompletionHandler: theCompletionHandler)
    }
    
    @objc public func callHandler(method:String,arguments:[String:Any]?,completionHandler:((Any?, Error?) -> Swift.Void)? = nil){
        wv.callHandler(method: method,arguments: arguments, completionHandler: completionHandler)
    }
    
    public func openNotification() {
        
    }
    
    public func offNotification() {
        
    }
}
