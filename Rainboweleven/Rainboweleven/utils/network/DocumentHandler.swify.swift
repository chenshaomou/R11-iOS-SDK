//
//  DocumentHandler.swify.swift
//  Rainboweleven
//
//  Created by 吕仕滔 on 2018/9/12.
//  Copyright © 2018年 chenshaomou. All rights reserved.
//

import Foundation
public class DocumentHandler: UIViewController, UIDocumentInteractionControllerDelegate {
    private var documentVC: UIDocumentInteractionController?
    typealias DocumentCallBack = (String) -> ()
    var documentCallBack: DocumentCallBack?
    func openFile(urlString: String, callBack: @escaping DocumentCallBack) {
        print("要打开的文件路径为： \(urlString)")
        let url = URL(fileURLWithPath: urlString)
        self.documentVC = UIDocumentInteractionController(url: url)
        if self.documentVC != nil {
            self.documentVC!.delegate = self
            let topView = UIApplication.shared.keyWindow?.rootViewController?.view
            // 弹出预览界面
//            self.documentVC!.presentPreview(animated: true)
            // 弹出分享对话框
            self.documentVC!.presentOpenInMenu(from: UIScreen.main.bounds, in: topView!, animated: true)
        }
        let result = ["successed":true,"downloading":false,"data":[],"error":[]].jsonString()
        callBack(result)
    }
    public func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        print("代理方法2: \(controller)")
    }
//    public func documentInteractionControllerWillPresentOptionsMenu(_ controller: UIDocumentInteractionController) {
//        print("代理方法1")
//    }
//    public func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
//        let topView = UIApplication.shared.keyWindow?.rootViewController?.view
//        return topView
//    }
//    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
//        let topVC = UIApplication.shared.keyWindow?.rootViewController
//        return topVC!
//    }
//    public func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
//        let topView = UIApplication.shared.keyWindow?.rootViewController?.view
//        return topView!.frame
//    }
}
