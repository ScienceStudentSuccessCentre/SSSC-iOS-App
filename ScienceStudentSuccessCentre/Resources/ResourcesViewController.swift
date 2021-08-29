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
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)

        if let url = URL(string: urlString) {
            webView?.load(URLRequest(url: url))
            webView?.allowsBackForwardNavigationGestures = true
        }
    }

    private func validateToolbarItems() {
        backButton.isEnabled = webView?.canGoBack ?? false
        forwardButton.isEnabled = webView?.canGoForward ?? false
    }

    private func evaluatePageTitle() {
        webView?.evaluateJavaScript("document.title") { [weak self] (result, error) -> Void in
            if let error = error {
                print("Failed to evalue page title with error: \(error)")
            } else {
                let suffix = " | Science Student Success Centre"
                var title = result as? String ?? self?.navigationItem.title ?? "Resources"
                if title.hasSuffix(suffix) {
                    title.removeLast(suffix.count)
                }
                self?.navigationItem.title = title
            }
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        validateToolbarItems()
        evaluatePageTitle()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        validateToolbarItems()
        evaluatePageTitle()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        validateToolbarItems()
        evaluatePageTitle()
    }

    @IBAction private func backButtonPressed(_ sender: UIBarButtonItem) {
        if webView?.canGoBack == true {
            webView?.goBack()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.validateToolbarItems()
                self?.evaluatePageTitle()
            }
        }
    }

    @IBAction private func forwardButtonPressed(_ sender: UIBarButtonItem) {
        if webView?.canGoForward == true {
            webView?.goForward()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.validateToolbarItems()
                self?.evaluatePageTitle()
            }
        }
    }

    @IBAction private func refreshButtonPressed(_ sender: UIBarButtonItem) {
        webView?.reload()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        webView?.frame = CGRect(origin: .zero, size: size)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
