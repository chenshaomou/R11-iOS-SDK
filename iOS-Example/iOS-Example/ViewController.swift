//
//  ViewController.swift
//  iOS-Example
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import UIKit
import WebKit
import Rainboweleven

class ViewController: UIViewController {
    
    var rwv:RWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        if let path = Bundle.main.path(forResource: "test", ofType: "html"){
            // rwv = Rainboweleven.loadLocalURL(path)
            rwv = RWebView(frame: UIScreen.main.bounds, type: .WKWebView)
            rwv?.loadLocalURL(url: path)
            rwv?.theNavigationDelegate = self
            // let uiwebView = rwv?.uiwebView
            // let wkwebView = rwv?.wkwebView
            self.view.addSubview(rwv!)
        }
       
        let bt = UIButton()
        self.view.addSubview(bt)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("原生调用JS方法", for: UIControl.State.normal)
        bt.backgroundColor = UIColor.red
        let high = NSLayoutConstraint(item: bt, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 44)
        //自身约束自己添加
        bt.addConstraint(high)
        //与其它的约束父节点添加
        let bottom = NSLayoutConstraint(item: bt, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: -20.0)
        let left = NSLayoutConstraint(item: bt, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 200.0)
        let right = NSLayoutConstraint(item: bt, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: -10.0)
        self.view.addConstraints([bottom,left,right])
        
        bt.addTarget(self, action: #selector(didClickNativeCallJSButton(button:)), for: UIControl.Event.touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveEvent(notify:)), name: NSNotification.Name("testEvent"), object: nil)
    }
    
    @objc func didClickNativeCallJSButton(button:UIButton){
        //
//        rwv?.callHandler(method:"contentappend",arguments: ["foo":"bar"], completionHandler: { (result, error) in
//            if let _result = result{
//                NSLog("return result is \(_result)")
//            }
//        })
        let params = ["a" : 1]
        NotificationCenter.default.post(name: NSNotification.Name("testOn"), object: nil, userInfo: params)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func receiveEvent(notify: NSNotification) {
        
    }
}

extension ViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 白名单机制
//        let whiteList = ["61.139.73.62"]
//        if let url = navigationAction.request.url, let host = url.host {
//            print("host = " + host)
//            let list = whiteList.filter { (item) -> Bool in
//                return host.contains(item)
//            }
//            if list.count == 0 {
//                decisionHandler(.cancel)
//                return
//            }
//        }
        decisionHandler(.allow)
    }
}
