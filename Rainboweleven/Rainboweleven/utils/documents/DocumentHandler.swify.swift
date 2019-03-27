//
//  DocumentHandler.swify.swift
//  Rainboweleven
//
//  Created by 吕仕滔 on 2018/9/12.
//  Copyright © 2018年 chenshaomou. All rights reserved.
//

import Foundation

// 文件打开处理类
public class DocumentHandler: UIViewController, UIDocumentInteractionControllerDelegate {
    
    // 类型回调
    typealias DocumentCallBack = (String) -> ()
    // 回调
    var documentCallBack: DocumentCallBack?
    
    var docmentVC: UIDocumentInteractionController?
    
    public let officeType = ["doc", "docx", "xls", "xlsx", "pdf", "ppt"]
    
    // 打开文件
    func openFile(urlString: String, callBack: @escaping DocumentCallBack) {
        print("DocumentHandler --- > open file urlString = \(urlString)")
        //
        var _urlString = urlString
        if (!_urlString.starts(with: "/")) {
            _urlString = "/" + _urlString
        }
        if (!_urlString.starts(with: "/Documents")) {
            _urlString = "/Documents" + _urlString
        }
        let path = NSHomeDirectory() + _urlString
        let url = URL(fileURLWithPath: path)
        
        if let fileName = url.relativeString.split(separator: "/").last, let ext = fileName.split(separator: ".").last, let keyWindow = UIApplication.shared.keyWindow, let rootVC = keyWindow.rootViewController {
            // 属于Office文档则用预览形式打开
            if (officeType.contains(ext.lowercased())) {
                // 采用 UIDocumentInteractionController 直接preview的话，会存在dismiss后视图失去焦点的问题
                // 其原因是因为 modalPresentationStyle 没有设置为overCurrentContext
                // 但 UIDocumentInteractionController 不是集成ViewController 不提供 modalPresentationStyle 属性
                // 因此office文件预览需要用一个viewController二次封装
                let docVC = DocViewController()
                docVC.url = url
                docVC.modalPresentationStyle = .overCurrentContext
                rootVC.present(docVC, animated: true) {}
            } else {
                // UIDocumentInteractionController 需要全局持有否则存在 UIDocumentInteractionController has gone away prematurely 的问题
                self.docmentVC = nil
                let vc = UIDocumentInteractionController(url: url)
                vc.delegate = self
                self.docmentVC = vc
                self.docmentVC?.presentOptionsMenu(from: UIScreen.main.bounds, in: rootVC.view, animated: true)
            }
        }
    }
    
    //
    public func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        print("DocumentHandler | DocumentInteractionControllerDidDismissOpenInMenu : \(controller)")
    }
    
    public func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        // 文档用其他应用打开则则发送通知
        let res = ["successed": true,
                   "data": []] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenDocument"), object: nil, userInfo: ["result" : res])
    }
    
}
