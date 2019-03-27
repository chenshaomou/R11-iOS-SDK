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
    
    public let officeType = ["doc", "docx", "xls", "xlsx", "pdf", "ppt"]
    
    override public func viewDidLoad() {
        //
        super.viewDidLoad()
        //
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
