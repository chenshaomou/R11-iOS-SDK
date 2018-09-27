//
//  Downloader.swift
//  Rainboweleven
//
//  Created by 吕仕滔 on 2018/9/10.
//  Copyright © 2018年 chenshaomou. All rights reserved.
//

import Foundation

public class Downloader : NSObject, URLSessionDownloadDelegate {
    typealias DownloadCallBack = (String) -> ()
    var downloadCallBack: DownloadCallBack?
    var fileName: String = ""
    var documentDir: String = ""
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }()
    
    func download(url: String, callBack: @escaping DownloadCallBack){
        // 用传入的url初始化请求
        let request = URLRequest(url: URL(string: url)!)
        // 初始化下载任务
        let downloadTast = session.downloadTask(with: request)
        // 根据url获取文件名
        self.fileName = URL(string: url)!.lastPathComponent
        // 根据url获取文件名然后拼接到下载目标路径上
        self.documentDir = "\(NSHomeDirectory())/Documents/" + self.fileName
        // 判断要下载的文件是否存在
        let fileManager = FileManager.default
        var result:String = ""
        // 若存在
        if fileManager.fileExists(atPath: self.documentDir) {
            result = ["successed":false,"downloading":false,"data":[],"error":["msg":"文件已存在"]].jsonString()
            callBack(result)
        } else { // 否则启动任务，传递闭包
            downloadTast.resume()
            self.downloadCallBack = callBack
        }
    }
    
    // 下载结束代理方法，一次调用
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        print("文件下载到临时目录：\(location)")
        let fileManager = FileManager.default
        var result:String = ""
        // 捕捉下载异常
        do {
            try fileManager.moveItem(atPath: location.path, toPath: self.documentDir)
            print("文件移动到沙盒：\(self.documentDir)")
            result = ["successed":true,"downloading":false,"data":["url":"/Documents/\(self.fileName)"],"error":[]].jsonString()
        } catch let e {
            result = ["successed":false,"downloading":false,"data":[],"error":["msg":"\(e)"]].jsonString()
        }
        if let callback = self.downloadCallBack {
            callback(result)
        }
    }
    
    // 监听进度代理方法，多次调用
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // 计算下载百分比
        let written: CGFloat = (CGFloat)(totalBytesWritten)
        let total: CGFloat = (CGFloat)(totalBytesExpectedToWrite)
        let precent = String.init(format: "%0.2f", written/total * 100)
        // 返回结果
        let result = ["successed":false,"downloading":true,"data":["precent":precent],"error":[]].jsonString()
        if let callback = self.downloadCallBack {
            callback(result)
        }
    }
}
