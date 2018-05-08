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
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var ebookTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.ebookTableView.isHidden = true
        self.ref = Database.database().reference()
        print("Coming from: " + parentScreen + ", withCategory: " + category + ", and sub category: " + subCategory)
        if (!self.category.isEmpty) { self.getEbookList() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
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
                DispatchQueue.main.async(execute: {
                    self.loading.stopAnimating()
                })
                self.showExceptionAlert(Constants.NETWORK_ERROR_HEADER, message: Constants.NETWORK_ERROR_MSG)
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
            self.loading.stopAnimating()
            self.ebookTableView.reloadData()
            self.ebookTableView.isHidden = false
        })
    }
}

extension EbookListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EbooksTableViewCell.height()
    }
}

extension EbookListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionArray.count;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionArray[section].uppercased()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = self.sectionArray[section]
        let dataArray = self.ebookDictionary[sectionName]
        return (dataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionName = self.sectionArray[indexPath.section]
        let dataArray = self.ebookDictionary[sectionName]
        
        if let data: EbookData = dataArray?[indexPath.row] {
            let cell = self.ebookTableView.dequeueReusableCell(withIdentifier: "EbooksTableViewCell") as! EbooksTableViewCell
            cell.setData(data)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sectionName = self.sectionArray[indexPath.section]
        let dataArray = self.ebookDictionary[sectionName]
        
        if let data: EbookData = dataArray?[indexPath.row] {
            let pdfView = self.storyboard?.instantiateViewController(withIdentifier: "PdfViewController") as! PdfViewController
            pdfView.ebookData = data
            pdfView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(pdfView, animated: true, completion: nil)
        }
    }
}

