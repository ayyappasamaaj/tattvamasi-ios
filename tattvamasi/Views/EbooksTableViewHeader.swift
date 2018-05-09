//
//  EbooksTableViewHeader.swift
//  tattvamasi
//
//  Created by Satya Surya on 5/8/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

open class EbooksTableViewHeader : UITableViewCell {
    
    @IBOutlet var sectionName: UILabel!
    
    
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
        return 40
        
    }
    
    open func setData(_ data: String) {
        self.sectionName.text = data
    }
    
}
