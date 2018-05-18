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
    @IBOutlet var date: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var time: UILabel!
    
    // Views for expansion
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var reminderButton: UIButton!
    @IBOutlet var directionsButton: UIButton!
    
    
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
    
    open class func height(showDetails: Bool) -> CGFloat {
        if (showDetails) {
            return 230
        } else {
            return 120
        }
        
    }
    
    open func setData(_ data: Any?) {
        if let data = data as? EventsData {
            
            self.selectionStyle = .none
            
            self.superView.layer.cornerRadius = 8
            self.superView.layer.borderWidth = 1
            self.superView.layer.borderColor = UIColor (hex: "740001").cgColor
            
            self.eventName.text = data.name
            self.address.text = data.venue
            
            self.date.text = data.date.dateAsString() + "\n" + data.date.monthAsString().uppercased()
            self.time.text = data.date.dayAsString() + " at " + data.date.timeAsString()
            
            // Views for expansion
            self.descLabel.text = data.desc

        }
    }
    
}
