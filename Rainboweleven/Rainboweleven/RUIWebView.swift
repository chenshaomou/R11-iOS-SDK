//
//  RUIWebView.swift
//  Rainboweleven
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import UIKit

class RUIWebView: UIWebView ,RWebViewProtocol{
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func loadURL(url: String, hash: String) {
        if let url = URL(string: url){
            let request = URLRequest(url: url)
            self.loadRequest(request)
        }else{
            //TODO: 读取出错界面
        }
    }
    
}
