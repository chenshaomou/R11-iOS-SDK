//
//  DocumentHandler.swify.swift
//  Rainboweleven
//
//  Created by 吕仕滔 on 2018/9/12.
//  Copyright © 2018年 chenshaomou. All rights reserved.
//

import Foundation
import QuickLook

// 文件打开处理类
public class DocumentHandler: UIViewController, UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    // 文件处理视图
    // private var documentVC: UIDocumentInteractionController?
    private var previewVC:  QLPreviewController?
    // 类型回调
    typealias DocumentCallBack = (String) -> ()
    // 回调
    var documentCallBack: DocumentCallBack?
    
    var fileUrl:URL?
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
        self.fileUrl = url
//        let ql = QLPreviewController()
//        ql.dataSource = self
//        ql.delegate = self
//        if let keyWindow = UIApplication.shared.keyWindow, let rootVC = keyWindow.rootViewController {
//            ql.view.frame = rootVC.view.bounds
//            rootVC.present(ql, animated: false) {
//
//            }
//
//            let result = [
//                "successed" : true,
//                "downloading" : false,
//                "data" :[],
//                "error":[]].jsonString()
//            callBack(result)
//        }
        //
        let  documentVC = UIDocumentInteractionController(url: url)
        documentVC.delegate = self
        // let topView = UIApplication.shared.keyWindow?.rootViewController?.view
        // 弹出预览界面
        // 弹出分享对话框
        // documentVC.presentOpenInMenu(from: UIScreen.main.bounds, in: topView!, animated: true)
        documentVC.presentPreview(animated: false)
        
        
    }
    
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        if let keyWindow = UIApplication.shared.keyWindow, let rootVC = keyWindow.rootViewController {
            if let nav = rootVC.navigationController {
                return nav
            }
            return rootVC
        }
        return UIViewController()
    }
    //
    public func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        print("DocumentHandler | DocumentInteractionControllerDidDismissOpenInMenu : \(controller)")
    }
    //
    public func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        //
    }
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.fileUrl! as NSURL
    }
    
    // previewControllerDidDismiss
    public func previewControllerDidDismiss(_ controller: QLPreviewController) {
        //
    }
    
}
