//
//  PoojaViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/30/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

class PoojaViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "poojaToList") {
            let targetVC = segue.destination as! EbookListViewController
            targetVC.parentScreen = "Pooja"
            targetVC.category = "pooja"
            targetVC.subCategory = ""
        }
    }
    
    @IBAction func goToList(_ sender: Any) {
        self.performSegue(withIdentifier: "poojaToList", sender: self)
    }
}

