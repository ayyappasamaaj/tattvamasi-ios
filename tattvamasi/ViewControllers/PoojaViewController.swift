//
//  PoojaViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/30/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PoojaViewController: BaseViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var tableData: [String] = [] {
        didSet {
            self.loading.stopAnimating()
            self.categoryTableView.reloadData()
            self.categoryTableView.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        categoryTableView.isHidden = true
        getCategories()
    }
    
    func getCategories() {
        EbookListWorker.getPoojaCategories { [weak self] data in
            self?.tableData = data
        }
    }
}

extension PoojaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PoojaViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = categoryTableView.dequeueReusableCell(withIdentifier: "EbooksTableViewCell") as? EbooksTableViewCell {
            cell.setTitle(title: tableData[indexPath.row].capitalized)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let payload: [String: Any] = ["category": "pooja",
                                      "subCategory": tableData[indexPath.row] as Any]
        navigate(to: "EbookListViewController", payload: payload)
    }
}

