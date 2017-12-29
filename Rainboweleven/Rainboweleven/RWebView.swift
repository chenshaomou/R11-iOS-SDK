//
//  RWebView.swift
//  Rainboweleven
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import UIKit
import WebKit

public protocol RWebViewProtocol {
    
    func loadRemoteURL(url: String,hash: String?) -> Void
    
    func loadLocalURL(url: String,hash: String?) -> Void
    
    var scrollView: UIScrollView { get }
    
    func callHandler(methodName:String,arguments:[String:Any]?,completionHandler:((Any?, Error?) -> Swift.Void)?)
}

open class RWebView: UIView,RWebViewProtocol {
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    internal var wv:RWebViewProtocol!
    open var scrollView: UIScrollView{
        get{
            return wv.scrollView
        }
    }
    
    internal static let  INIT_SCRIPT = "function getJsBridge(){window._jsf=window._jsf||{};return{call:function(b,a,c){if('function'==typeof a){c=a;a={}}else{a={'param':a}}if('function'==typeof c){window.jscb=window.jscb||0;var d='jscb'+window.jscb++;window[d]=c;a._jscbstub=d}a=JSON.stringify(a||{});return window._jswk?prompt(window._jswk+b,a):'function'==typeof _jsBridge?_jsBridge(b,a):_jsBridge.call(b,a)},register:function(b,a){'object'==typeof b?Object.assign(window._jsf,b):window._jsf[b]=a}}}jsBridge=getJsBridge()"
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpWebView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpWebView()
    }
    
    fileprivate func setUpWebView() {
        //如果是iOS 8 以上系统就用 wkwebview 否用用 uiwebview
        if((UIDevice.current.systemVersion as NSString).floatValue >= 8.0){
            wv = RWKWebView(frame: frame)
        }else{
            wv = RUIWebView(frame: frame)
        }
        
        let uv = wv as! UIView
        self.addSubview(uv)
    }
    
    public func loadRemoteURL(url: String, hash: String? = nil) {
        wv.loadRemoteURL(url:url, hash: hash)
    }
    
    public func loadLocalURL(url: String, hash: String? = nil) {
        wv.loadLocalURL(url:url, hash: hash)
    }
    
    public func callHandler(methodName:String,arguments:[String:Any]?,completionHandler:((Any?, Error?) -> Swift.Void)? = nil){
        wv.callHandler(methodName: methodName, arguments: arguments, completionHandler: completionHandler)
    }
}
