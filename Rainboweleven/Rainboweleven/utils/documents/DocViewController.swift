//
//  DocViewController.swift
//  Rainboweleven
//
//  Created by Zhang Zhang on 2019/3/27.
//  Copyright © 2019 chenshaomou. All rights reserved.
//

import UIKit

public class DocViewController: UIViewController , UIDocumentInteractionControllerDelegate {
    
    public var url:URL? = nil
    
    override public func viewDidLoad() {
        //
        super.viewDidLoad()
        self.view.frame = UIScreen.main.bounds
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.view.backgroundColor = color
        //
        let bt = UIButton()
        self.view.addSubview(bt)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("加载中", for: UIControl.State.normal)
        bt.backgroundColor = UIColor.blue
        let high = NSLayoutConstraint(item: bt, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 44)
        let width = NSLayoutConstraint(item: bt, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 100)
        //自身约束自己添加
        bt.addConstraints([high, width])
        let centerX = NSLayoutConstraint(item: bt, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: bt, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraints([centerY, centerX])
//
//        bt.addTarget(self, action: #selector(self.show(_:)), for: UIControl.Event.touchUpInside)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {[weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.showPreview()
        })
    }
    
    @objc func show(_ sender: UIButton) {
        self.showPreview()
    }
    
    private func showPreview() {
        // show
        if let fileUrl = url {
            let documentVC = UIDocumentInteractionController(url: fileUrl)
            documentVC.delegate = self
            documentVC.presentPreview(animated: true)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        //
//        if let keyWindow = UIApplication.shared.keyWindow, let rootVC = keyWindow.rootViewController {
//            return rootVC
//        }
        return self
    }
    
    public func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        // 文档用其他应用打开则则发送通知
        let res = ["successed": true,
                   "data": []] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenDocument"), object: nil, userInfo: ["result" : res])
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
