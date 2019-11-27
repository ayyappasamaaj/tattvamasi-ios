//
//  WKWebView+Extension.swift
//  SKCC
//
//  Created by Suryanarayanan, Satyanarayan G on 2/10/19.
//  Copyright © 2019 Suryanarayanan, Satyanarayan G. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {

    convenience init(viewController: UIViewController, backingView: UIView, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: backingView.frame.size.width, height: backingView.frame.size.height))
        self.init(frame: customFrame, configuration: configuration)
        self.applyConstraints(wVC: backingView)
    }

    func applyConstraints(wVC: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        wVC.addSubview(self)
        self.topAnchor.constraint(equalTo: wVC.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: wVC.rightAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: wVC.leftAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: wVC.bottomAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: wVC.heightAnchor).isActive = true
    }

}
