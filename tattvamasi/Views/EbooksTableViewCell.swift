//
//  EbooksTableViewCell.swift
//  tattvamasi
//
//  Created by Satya Surya on 5/4/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

open class EbooksTableViewCell : UITableViewCell {
    
    @IBOutlet var superView: UIView!
    @IBOutlet var bookName: UILabel!
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
    }
    
    open class func height() -> CGFloat {
        return 60
        
    }
    
    open func setData(_ data: Any?) {
        if let data = data as? EbookData {
            
            self.selectionStyle = .none
            
            self.superView.layer.cornerRadius = 8
            self.superView.layer.borderWidth = 1
            self.superView.layer.borderColor = UIColor (hex: "740001").cgColor
            
            self.bookName.text = data.title
            
        }
    }
    
}

