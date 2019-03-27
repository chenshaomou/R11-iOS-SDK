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
        super.viewDidLoad()
        
        if let fileUrl = url {
            
            let  documentVC = UIDocumentInteractionController(url: fileUrl)
            documentVC.delegate = self
            documentVC.presentPreview(animated: true)
        }
    }
    
    
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        return self
    }
    //
    public func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        print("DocumentHandler | DocumentInteractionControllerDidDismissOpenInMenu : \(controller)")
    }
    
    public func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        let res = ["successed": false,
                   "data": []] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenDocument"), object: nil, userInfo: ["result" : res])
        
        self.dismiss(animated: true, completion: nil)
    }

}
