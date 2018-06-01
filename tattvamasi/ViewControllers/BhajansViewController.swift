//
//  BhajansViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/27/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

class BhajansViewController: UIViewController {
    
    var selectedSubCategory: String = ""
    
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
            targetVC.subCategory = self.selectedSubCategory
        }
    }
    
    @IBAction func goToList(_ sender: Any) {
        switch (sender as AnyObject).tag {
        case 1:
            self.selectedSubCategory = "ganesha"
            break
        case 2:
            self.selectedSubCategory = "guru"
            break
        case 3:
            self.selectedSubCategory = "muruga"
            break
        case 4:
            self.selectedSubCategory = "devi"
            break
        case 5:
            self.selectedSubCategory = "shiva"
            break
        case 6:
            self.selectedSubCategory = "vishnu"
            break
        case 7:
            self.selectedSubCategory = "rama"
            break
        case 8:
            self.selectedSubCategory = "hanuman"
            break
        case 9:
            self.selectedSubCategory = "ayyappan"
            break
        default:
            self.selectedSubCategory = ""
            break
        }
        self.performSegue(withIdentifier: "bhajansToList", sender: self)
    }
}
