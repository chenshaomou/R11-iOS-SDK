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
    
    func evaluteJavaScriptSafey(javaScript : String, theCompletionHandler: @escaping ((Any?, Error?) -> Swift.Void))
    
    func callHandler(method:String,arguments:[String:Any]?,completionHandler:((Any?, Error?) -> Swift.Void)?)
}

open class RWebView: UIView,RWebViewProtocol {
 
    internal var wv:RWebViewProtocol!
    open var scrollView: UIScrollView{
        get{
            return wv.scrollView
        }
    }
    
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
            wv.scrollView.bounces = true
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
    
    public func evaluteJavaScriptSafey(javaScript: String, theCompletionHandler: @escaping ((Any?, Error?) -> Void)) {
        wv.evaluteJavaScriptSafey(javaScript: javaScript, theCompletionHandler: theCompletionHandler)
    }
    
    public func callHandler(method:String,arguments:[String:Any]?,completionHandler:((Any?, Error?) -> Swift.Void)? = nil){
        wv.callHandler(method: method,arguments: arguments, completionHandler: completionHandler)
    }
}
