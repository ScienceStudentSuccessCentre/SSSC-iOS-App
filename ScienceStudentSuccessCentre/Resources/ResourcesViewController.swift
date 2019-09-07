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
    private var statusBarBackground: UIView?
    private var webView: WKWebView?
    private var activityIndicator: UIActivityIndicatorView!
    private let urlString = "http://sssc.carleton.ca/resources"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: view.frame)
        webView?.navigationDelegate = self
        view.addSubview(webView!)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.style = .gray
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        let frame = UIApplication.shared.statusBarFrame
        let statusBarBackground = UIView(frame: frame)
        statusBarBackground.backgroundColor = UIColor(.steelblue)
        view.addSubview(statusBarBackground)
        self.statusBarBackground = statusBarBackground

        if let url = URL(string: urlString) {
            webView?.load(URLRequest(url: url))
            webView?.allowsBackForwardNavigationGestures = true
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        webView?.frame = CGRect(origin: .zero, size: size)
        guard let oldFrame = statusBarBackground?.frame else { return }
        statusBarBackground?.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: size.width, height: oldFrame.height)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
