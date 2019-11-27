//
//  EbookListViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/30/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit


class EbookListViewController: BaseViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var ebookTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var category: String?
    var subCategory: String?
    var selectedEbook: EbookData?
    
    var ebookArray: [EbookData] = []
    var ebookDictionary: [String: [EbookData]] = [:]
    var searchResultDictionary: [String: [EbookData]] = [:]
    var searchResutsSections: [String] = []
    var sectionArray: [String] = []
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.ebookTableView.isHidden = true
        EbookListWorker.getEbookList(for: category, subCategory: subCategory) { [weak self] data in
            self?.categorizeAndUpdate(ebookArray: data)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(backToPotrait),
                                               name: NSNotification.Name(rawValue: Constants.PDFDismissNotification), object: nil)
    }

    override func setupPayload() {
        if let pl = payload {
            if let category = pl["category"] as? String {
                self.category = category
            }
            if let subCategory = pl["subCategory"] as? String {
                self.subCategory = subCategory
            }
        }
    }
    
    @objc func backToPotrait() {
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }
    
    func categorizeAndUpdate(ebookArray: [EbookData]) {
        
        self.ebookArray = ebookArray
        self.ebookDictionary = ebookArray.categorise { $0.language }
        self.sectionArray = self.ebookDictionary.keys.sorted()
        
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
        
        let ebookList = self.ebookArray.filter {
            $0.title.lowercased().range(of: searchText.lowercased()) != nil
        }
        self.searchResultDictionary = ebookList.categorise { $0.language }
        self.searchResutsSections = self.searchResultDictionary.keys.sorted()
    }
}

extension EbookListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EbooksTableViewCell.cellHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return EbooksTableViewHeader.cellHeight
    }
}

extension EbookListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return inSearchMode ? searchResutsSections.count : sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = inSearchMode ? searchResutsSections[section].uppercased() : sectionArray[section].uppercased()
        if let cell = self.ebookTableView.dequeueReusableCell(withIdentifier: "EbooksTableViewHeader") as? EbooksTableViewHeader {
            cell.sectionName.text = header
            return cell
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = inSearchMode ? searchResutsSections[section] : sectionArray[section]
        let dataArray = inSearchMode ? searchResultDictionary[sectionName] : ebookDictionary[sectionName]
        return dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionName = inSearchMode ? searchResutsSections[indexPath.section] : sectionArray[indexPath.section]
        guard let dataArray = inSearchMode ? searchResultDictionary[sectionName] : ebookDictionary[sectionName],
            let cell = self.ebookTableView.dequeueReusableCell(withIdentifier: "EbooksTableViewCell") as? EbooksTableViewCell else {
                return UITableViewCell()
        }

        let data: EbookData = dataArray[indexPath.row]
        cell.setData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sectionName = inSearchMode ? searchResutsSections[indexPath.section] : sectionArray[indexPath.section]
        guard let dataArray = inSearchMode ? searchResultDictionary[sectionName] : ebookDictionary[sectionName] else {
            return
        }
        
        let ebook = dataArray[indexPath.row]
        navigate(to: "PdfViewController", transition: .present, payload: ["ebook": ebook])
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
