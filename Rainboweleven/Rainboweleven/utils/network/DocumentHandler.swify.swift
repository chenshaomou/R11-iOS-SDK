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
    // 文件处理视图
    private var documentVC: UIDocumentInteractionController?
    // 类型回调
    typealias DocumentCallBack = (String) -> ()
    // 回调
    var documentCallBack: DocumentCallBack?
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
        let path = NSHomeDirectory() + urlString
        let url = URL(fileURLWithPath: path)
        //
        self.documentVC = UIDocumentInteractionController(url: url)
        //
        if let documentVC = self.documentVC {
            documentVC.delegate = self
            let topView = UIApplication.shared.keyWindow?.rootViewController?.view
            // 弹出预览界面
            // 弹出分享对话框
            documentVC.presentOpenInMenu(from: UIScreen.main.bounds, in: topView!, animated: true)
        }
        let result = [
            "successed" : true,
            "downloading" : false,
            "data" :[],
            "error":[]].jsonString()
        callBack(result)
    }
    //
    public func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        print("DocumentHandler | DocumentInteractionControllerDidDismissOpenInMenu : \(controller)")
    }
    //
    public func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        //
    }
}
