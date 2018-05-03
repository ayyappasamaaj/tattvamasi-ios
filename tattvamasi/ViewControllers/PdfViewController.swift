//
//  PdfViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/30/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController, UIWebViewDelegate {
    
    var ebookData: EbookData!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var pdfWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Test Data
        self.ebookData = EbookData()
        self.ebookData.title = "Sastha Varugirar"
        self.ebookData.url = "https://s3-us-west-2.amazonaws.com/ayyappasamaajdrive/Bhajans/Ayyappan/Maha+Sastha+Varavu.pdf"
        
        self.header.text = self.ebookData.title
        let url = URL (string: self.ebookData.url)
        let requestObj = URLRequest(url: url!);
        self.pdfWebView.delegate = self
        self.pdfWebView.loadRequest(requestObj)
        self.pdfWebView.isHidden = true
    }
    
    @objc func canRotate() -> Void {}
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.isMovingFromParentViewController) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
    
    func webViewDidStartLoad(_ webView : UIWebView) {
        self.loading.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        self.loading.stopAnimating()
        self.pdfWebView.isHidden = false
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.loading.stopAnimating()
        let alert = UIAlertController(title: Constants.WEBVIEW_LOAD_ERROR_HEADER, message: Constants.WEBVIEW_LOAD_ERROR_MSG, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closePdfView(_ sender: Any) {
        self.dismiss(animated: false, completion: nil);
    }
    
}

