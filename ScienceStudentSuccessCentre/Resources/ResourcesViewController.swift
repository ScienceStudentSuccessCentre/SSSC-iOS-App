//
//  ResourcesViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Gina Bak on 2018-11-26.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import WebKit

class ResourcesViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    var statusBar: UIView!
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://sssc.carleton.ca/resources")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        statusBar.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        statusBar.backgroundColor = .clear
    }

}
