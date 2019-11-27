//
//  PdfViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/30/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit
import WebKit

class PdfViewController: BaseViewController, UIWebViewDelegate {
    
    var ebookData: EbookData?
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var backingView: UIView!
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setupWebView()
    }

    override func setupPayload() {
        if let book = payload?["ebook"] as? EbookData {
            ebookData = book
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let book = ebookData,
            let url = URL(string: book.url) {
            header.text = book.title
            webView?.load(URLRequest(url: url))
            loading.startAnimating()
        }
    }

    func setupWebView() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(viewController: self, backingView: self.backingView, configuration: config)
        webView?.navigationDelegate = self
    }
    
    @objc func canRotate() -> Void {}
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.PDFDismissNotification), object: nil)
    }
    
    @IBAction func closePdfView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }

}

extension PdfViewController: WKNavigationDelegate {

    func webView(_: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loading.stopAnimating()
        self.showExceptionAlert(Constants.WEBVIEW_LOAD_ERROR_HEADER, message: Constants.WEBVIEW_LOAD_ERROR_MSG)
    }
}

