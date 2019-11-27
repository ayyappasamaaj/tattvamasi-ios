//
//  EbooksTableViewCell.swift
//  tattvamasi
//
//  Created by Satya Surya on 5/4/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

class EbooksTableViewCell: UITableViewCell {

    static var cellHeight: CGFloat = 60
    @IBOutlet var superView: UIView!
    @IBOutlet var bookName: UILabel! 
    
    func setData(_ data: EbookData) {
        self.selectionStyle = .none
        self.superView.layer.cornerRadius = 8
        self.superView.layer.borderWidth = 1
        self.superView.layer.borderColor = UIColor (hex: "740001").cgColor

        self.bookName.text = data.title
    }
    
    func setTitle(title: String) {
        
        self.selectionStyle = .none
        self.superView.layer.cornerRadius = 8
        self.superView.layer.borderWidth = 1
        self.superView.layer.borderColor = UIColor (hex: "740001").cgColor
        
        self.bookName.text = title
    }
    
}

