//
//  UIViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 5/3/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showExceptionAlert(_ title: String, message: String) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
}
