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
    
    var ebookArray: [EbookData] = []
    var ebookDictionary: Dictionary<String, Array<EbookData>> = [:]
    var searchResultDictionary: Dictionary<String, Array<EbookData>> = [:]
    var searchResutsSections: [String] = []
    var sectionArray: [String] = []
    var inSearchMode = false
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var ebookTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        var ebookList: [EbookData] = []
        for record in ebookArray {
            let ebook: EbookData = EbookData()
            ebook.title = (record as! [String : AnyObject])["itemTitle"] as! String
            ebook.url = (record as! [String : AnyObject])["fileUrl"] as! String
            ebook.language = (record as! [String : AnyObject])["language"] as! String
            ebookList.append(ebook)
        }
        
        self.ebookArray = ebookList
        self.ebookDictionary = ebookList.categorise { $0.language }
        self.sectionArray = (self.ebookDictionary.keys).sorted()
        
        DispatchQueue.main.async(execute: {
            self.loading.stopAnimating()
            self.ebookTableView.reloadData()
            self.ebookTableView.isHidden = false
        })
    }
    
    func filterContentForSearchText(searchText: String) {
        if self.ebookArray.isEmpty {
            self.searchResultDictionary = [:]
            self.searchResutsSections = []
            return
        }
        
        let ebookList: [EbookData] = self.ebookArray.filter { $0.title.lowercased().range(of: searchText.lowercased()) != nil }
        self.searchResultDictionary = ebookList.categorise { $0.language }
        self.searchResutsSections = (self.searchResultDictionary.keys).sorted()
    }
}

extension EbookListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EbooksTableViewCell.height()
    }
}

extension EbookListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (inSearchMode) {
            return self.searchResutsSections.count
        }
        return self.sectionArray.count;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var header: String = ""
        if (inSearchMode) {
            header = self.searchResutsSections[section].uppercased()
        } else {
            header = self.sectionArray[section].uppercased()
        }
        
        let cell = self.ebookTableView.dequeueReusableCell(withIdentifier: "EbooksTableViewHeader") as! EbooksTableViewHeader
        cell.setData(header)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (inSearchMode) {
            let sectionName = self.searchResutsSections[section]
            let dataArray = self.searchResultDictionary[sectionName]
            return (dataArray?.count)!
        } else {
            let sectionName = self.sectionArray[section]
            let dataArray = self.ebookDictionary[sectionName]
            return (dataArray?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var dataArray: Array<EbookData> = []
        
        if (inSearchMode) {
            let sectionName = self.searchResutsSections[indexPath.section]
            dataArray = self.searchResultDictionary[sectionName]!
        } else {
            let sectionName = self.sectionArray[indexPath.section]
            dataArray = self.ebookDictionary[sectionName]!
        }
        
        let data: EbookData = dataArray[indexPath.row]
        let cell = self.ebookTableView.dequeueReusableCell(withIdentifier: "EbooksTableViewCell") as! EbooksTableViewCell
        cell.setData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var dataArray: Array<EbookData> = []
        
        if (inSearchMode) {
            let sectionName = self.searchResutsSections[indexPath.section]
            dataArray = self.searchResultDictionary[sectionName]!
        } else {
            let sectionName = self.sectionArray[indexPath.section]
            dataArray = self.ebookDictionary[sectionName]!
        }
        
        let data: EbookData = dataArray[indexPath.row]
        let pdfView = self.storyboard?.instantiateViewController(withIdentifier: "PdfViewController") as! PdfViewController
        pdfView.ebookData = data
        pdfView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(pdfView, animated: true, completion: nil)
    }
}

extension EbookListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text == nil || searchBar.text == "") {
            inSearchMode = false
            view.endEditing(true)
            self.ebookTableView.reloadData()
        } else {
            inSearchMode = true
            self.filterContentForSearchText(searchText: searchBar.text!)
            self.ebookTableView.reloadData()
        }
    }
}
