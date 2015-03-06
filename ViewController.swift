//
//  ViewController.swift
//  PopupTest
//
//  Created by Sidney San Martín on 3/6/15.
//  Copyright (c) 2015 Coordinated Hackers. All rights reserved.
//

import UIKit
import WebKit

func pathForBuggyWKWebView(filePath: NSURL) -> NSURL? {
    let fileMgr = NSFileManager.defaultManager()
    let tmpPath = NSURL(fileURLWithPath: NSTemporaryDirectory())!.URLByAppendingPathComponent("www")
    var error: NSErrorPointer = nil
    if !fileMgr.createDirectoryAtURL(tmpPath, withIntermediateDirectories: true, attributes: nil, error: error) {
        println("Couldn't create www subdirectory. \(error)")
        return nil
    }
    let dstPath = tmpPath.URLByAppendingPathComponent(filePath.lastPathComponent!)
    fileMgr.copyItemAtURL(filePath, toURL: dstPath, error: nil)
    fileMgr.replaceItemAtURL(dstPath, withItemAtURL: filePath, backupItemName: nil, options: nil, resultingItemURL: nil, error: error)
    return dstPath
}

class Modal {
    
    var holdSelf: Modal? = nil
    let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    init() {
        holdSelf = self
        window.backgroundColor = UIColor.clearColor()
        window.rootViewController = UIViewController()
    }
}

class ViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.UIDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(NSURLRequest(URL: pathForBuggyWKWebView(NSBundle.mainBundle().URLForResource("index", withExtension: "html", subdirectory: "html")!)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let modal = Modal()
        let webView = WKWebView(frame: modal.window.frame, configuration: configuration)
        webView.opaque = false
        webView.backgroundColor = UIColor.clearColor()
        webView.scrollView.scrollEnabled = false
        modal.window.rootViewController!.view.backgroundColor = UIColor.clearColor()
        modal.window.rootViewController!.view.addSubview(webView)
        modal.window.makeKeyAndVisible()
        return webView
    }

}

