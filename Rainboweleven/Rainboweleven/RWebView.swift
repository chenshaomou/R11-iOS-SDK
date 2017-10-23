//
//  RWebView.swift
//  Rainboweleven
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import UIKit
import WebKit

protocol RWebViewProtocol {
    func loadURL(url: String,hash: String) -> Void
    var scrollView: UIScrollView { get }
    
}

public class RWebView: UIView,RWebViewProtocol {
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var wv:RWebViewProtocol!
    var scrollView: UIScrollView{
        get{
            return wv.scrollView
        }
    }
    
    static let  INIT_SCRIPT = "function getJsBridge(){window._dsf=window._dsf||{};return{call:function(b,a,c){'function'==typeof a&&(c=a,a={});if('function'==typeof c){window.dscb=window.dscb||0;var d='dscb'+window.dscb++;window[d]=c;a._dscbstub=d}a=JSON.stringify(a||{});return window._dswk?prompt(window._dswk+b,a):'function'==typeof _dsbridge?_dsbridge(b,a):_dsbridge.call(b,a)},register:function(b,a){'object'==typeof b?Object.assign(window._dsf,b):window._dsf[b]=a}}}dsBridge=getJsBridge()"
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //如果是iOS 8 以上系统就用 wkwebview 否用用 uiwebview
        if((UIDevice.current.systemVersion as NSString).floatValue >= 8.0){
            wv = RWKWebView(frame: frame)
        }else{
            wv = RUIWebView(frame: frame)
        }
        
        let uv = wv as! UIView
        self.addSubview(uv)
    }
    
    func loadURL(url: String, hash: String) {
        wv.loadURL(url:url, hash: hash)
    }

}
