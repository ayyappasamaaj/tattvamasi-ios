//
//  BaseViewController.swift
//  tattvamasi
//
//  Created by Suryanarayanan, Satyanarayan G on 11/22/19.
//  Copyright © 2019 Satya Surya. All rights reserved.
//

import UIKit

enum Transition {
    case push
    case present
}

class BaseViewController: UIViewController {

    var payload: [String: Any]? {
        didSet {
            self.setupPayload()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultNavBar()
    }

    func setupPayload() {
        // intentionally left blank
    }

    func setDefaultNavBar() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 32))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "aysa_header.png")
        self.navigationItem.titleView = imageView

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.45, green: 0, blue: 0, alpha: 1.0)
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
            self.navigationItem.titleView = imageView
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.45, green: 0, blue: 0, alpha: 1.0)
            self.navigationController?.navigationBar.isTranslucent = false
        }
    }

    func navigate(to destination: String, storyboard: String = "Main", transition: Transition = .push, payload: [String: Any]? = nil) {

        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: destination)
        guard let childVC = destVC as? BaseViewController else {
            return
        }
        childVC.payload = payload
        switch transition {
        case .push:
            self.navigationController?.pushViewController(childVC, animated: true)
        case .present:
            self.present(childVC, animated: true, completion: nil)
        }
    }
}
