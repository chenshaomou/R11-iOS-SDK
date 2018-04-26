//
//  RUIWebView.swift
//  Rainboweleven
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import UIKit

internal class RUIWebView: UIWebView ,RWebViewProtocol {

    func loadLocalURL(url: String, hash: String?) {
        
        let fileUrl = URL(fileURLWithPath: url)
        let request = URLRequest(url: fileUrl)
        self.loadRequest(request)
    }
    
    func loadRemoteURL(url: String, hash: String? = nil) {
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
    
}
