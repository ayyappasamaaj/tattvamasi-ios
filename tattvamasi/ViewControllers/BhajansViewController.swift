//
//  BhajansViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/27/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

class BhajansViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "bhajansToList") {
            let targetVC = segue.destination as! EbookListViewController
            targetVC.parentScreen = "Bhajans"
            targetVC.category = "bhajans"
            targetVC.subCategory = "ayyappan"
        }
    }
    
    @IBAction func goToList(_ sender: Any) {
        self.performSegue(withIdentifier: "bhajansToList", sender: self)
    }
}
