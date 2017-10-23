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
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
