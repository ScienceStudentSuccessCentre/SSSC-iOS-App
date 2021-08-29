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

    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private weak var forwardButton: UIBarButtonItem!
    @IBOutlet private weak var refreshButton: UIBarButtonItem!
    
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

    private func validateToolbarItems() {
        backButton.isEnabled = webView?.canGoBack ?? false
        forwardButton.isEnabled = webView?.canGoForward ?? false
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        validateToolbarItems()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        validateToolbarItems()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        validateToolbarItems()
    }

    @IBAction private func backButtonPressed(_ sender: UIBarButtonItem) {
        if webView?.canGoBack == true {
            webView?.goBack()
        }
    }

    @IBAction private func forwardButtonPressed(_ sender: UIBarButtonItem) {
        if webView?.canGoForward == true {
            webView?.goForward()
        }
    }

    @IBAction private func refreshButtonPressed(_ sender: UIBarButtonItem) {
        webView?.reload()
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
