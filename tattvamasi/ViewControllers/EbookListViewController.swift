//
//  EbookListViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/30/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EbookListViewController: UIViewController {
    
    var ref: DatabaseReference!
    var parentScreen: String = ""
    var category: String = ""
    var subCategory: String = ""
    var selectedEbook: EbookData!
    var ebookDictionary: Dictionary<String, Array<EbookData>> = [:]
    var sectionArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        print("Coming from: " + parentScreen + ", withCategory: " + category + ", and sub category: " + subCategory)
        if (!self.category.isEmpty) { self.getEbookList() }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        switch self.parentScreen {
        case "Home":
            self.performSegue(withIdentifier: "listToHome", sender: self)
            break
        case "Bhajans":
            self.performSegue(withIdentifier: "listToBhajans", sender: self)
            break
        case "Pooja":
            self.performSegue(withIdentifier: "listToPooja", sender: self)
            break
        default:
            self.performSegue(withIdentifier: "listToHome", sender: self)
            break
        }
    }
    
    /*
     * Calling Firebase database to get the
     * List of books
     *
     */
    func getEbookList() {
        if (self.subCategory.isEmpty) {
            self.ref.child(self.category).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSArray
                self.categorizeAndUpdate(ebookArray: value!)
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            self.ref.child(self.category).child(self.subCategory).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSArray
                self.categorizeAndUpdate(ebookArray: value!)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func categorizeAndUpdate(ebookArray: NSArray) {
        let ebookList: NSMutableArray = NSMutableArray()
        for record in ebookArray {
            let ebook: EbookData = EbookData()
            ebook.title = (record as! [String : AnyObject])["itemTitle"] as! String
            ebook.url = (record as! [String : AnyObject])["fileUrl"] as! String
            ebook.language = (record as! [String : AnyObject])["language"] as! String
            ebookList.add(ebook)
        }
        
        self.ebookDictionary = ebookList.categorise { ($0 as! EbookData).language } as! Dictionary<String, Array<EbookData>>
        self.sectionArray = (ebookDictionary.keys).sorted()
        
        DispatchQueue.main.async(execute: {
            /*self.loading.stopAnimating()
            self.tableView.reloadData()
            self.tableView.isHidden = false*/
        })
    }
}

public extension Sequence {
    func categorise<U : Hashable>(_ key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = key(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}

