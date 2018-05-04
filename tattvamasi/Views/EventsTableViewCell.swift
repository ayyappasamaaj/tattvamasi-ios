//
//  EventsTableViewCell.swift
//  tattvamasi
//
//  Created by Satya Surya on 5/3/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

open class EventsTableViewCell : UITableViewCell {
    
    @IBOutlet var superView: UIView!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var month: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var time: UILabel!
    
    
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
        return 120
        
    }
    
    open func setData(_ data: Any?) {
        if let data = data as? EventsData {
            
            self.selectionStyle = .none
            
            self.superView.layer.cornerRadius = 8
            self.superView.layer.borderWidth = 1
            self.superView.layer.borderColor = UIColor (hex: "740001").cgColor
            
            self.eventName.text = data.name
            self.address.text = "Venue: " + data.venue
            
            self.month.text = data.date.monthAsString().uppercased()
            self.date.text = data.date.dateAsString()
            self.time.text = "Starts at: " + data.date.timeAsString()

        }
    }
    
}
