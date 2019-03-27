//
//  TestViewController.swift
//  iOS-Example
//
//  Created by Zhang Zhang on 2019/3/27.
//  Copyright © 2019 chenshaomou. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view.
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
    }
    
    @objc func didClickNativeCallJSButton(button:UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
