//
//  DonateViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/26/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

class DonateViewController: UIViewController {
    
    @IBOutlet weak var donateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.donateButton.layer.borderWidth = 1.0
        self.donateButton.layer.cornerRadius = 5.0
        self.donateButton.layer.borderColor = UIColor (hex: "740001").cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donate(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: Constants.PAYPAL_DONATION_URL)!)
    }
    
}
