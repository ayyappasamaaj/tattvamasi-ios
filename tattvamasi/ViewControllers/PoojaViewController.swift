//
//  PoojaViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/30/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PoojaViewController: UIViewController {
    
    var ref: DatabaseReference!
    var tableData: [String] = []
    var selectedSubCategory: String = ""
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.ref = Database.database().reference()
        self.categoryTableView.isHidden = true
        self.getCategories()
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
            targetVC.subCategory = self.selectedSubCategory
        }
    }
    
    func getCategories() {
        self.ref.child("pooja_categories").observeSingleEvent(of: .value, with: { (snapshot) in
            self.tableData = snapshot.value as! [String]
            DispatchQueue.main.async(execute: {
                self.loading.stopAnimating()
                self.categoryTableView.reloadData()
                self.categoryTableView.isHidden = false
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension PoojaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EbooksTableViewCell.height()
    }
}

extension PoojaViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: "EbooksTableViewCell") as! EbooksTableViewCell
        cell.setTitle(title: self.tableData[indexPath.row].capitalized)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSubCategory = self.tableData[indexPath.row]
        self.performSegue(withIdentifier: "poojaToList", sender: self)
    }
}

