//
//  ViewController.swift
//  iOS-Example
//
//  Created by chenshaomou on 23/10/2017.
//  Copyright © 2017 chenshaomou. All rights reserved.
//

import UIKit
import Rainboweleven

class ViewController: UIViewController {
    
    var rwv:RWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        if let path = Bundle.main.path(forResource: "test", ofType: "html"){
            rwv = Rainboweleven.loadLocalURL(path)
            self.view.addSubview(rwv!)
        }
       
        let bt = UIButton()
        self.view.addSubview(bt)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("原生button按钮，原生调用JS方法", for: UIControlState.normal)
        bt.backgroundColor = UIColor.red
        let high = NSLayoutConstraint(item: bt, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 44)
        //自身约束自己添加
        bt.addConstraint(high)
        //与其它的约束父节点添加
        let bottom = NSLayoutConstraint(item: bt, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -20.0)
        let left = NSLayoutConstraint(item: bt, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 10.0)
        let right = NSLayoutConstraint(item: bt, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -10.0)
        self.view.addConstraints([bottom,left,right])
        
        bt.addTarget(self, action: #selector(didClickNativeCallJSButton(button:)), for: UIControlEvents.touchUpInside)
        
    }
    
    @objc func didClickNativeCallJSButton(button:UIButton){
        //
        rwv?.callHandler(method:"contentappend",arguments: ["foo":"bar"], completionHandler: { (result, error) in
            if let _result = result{
                NSLog("return result is \(_result)")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

