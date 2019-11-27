//
//  EventsTableViewCell.swift
//  tattvamasi
//
//  Created by Satya Surya on 5/3/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

open class EventsTableViewCell : UITableViewCell {

    static let heightWithDesc: CGFloat = 230.00

    @IBOutlet var superView: UIView!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var time: UILabel!
    
    // Views for expansion
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var reminderButton: UIButton!
    @IBOutlet var directionsButton: UIButton!

    func setData(_ data: EventsData) {
        self.selectionStyle = .none

        self.superView.layer.cornerRadius = 8
        self.superView.layer.borderWidth = 1
        self.superView.layer.borderColor = UIColor (hex: "740001").cgColor

        self.eventName.text = data.name
        self.address.text = data.venue

        guard let date = data.date else { return }

        self.date.text = date.dateAsString() + "\n" + date.monthAsString().uppercased()
        self.time.text = date.dayAsString() + " at " + date.timeAsString()

        // Views for expansion
        self.descLabel.text = data.desc
    }
    
}

class EventsWithoutDescCell: UITableViewCell {
    @IBOutlet var superView: UIView!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var time: UILabel!

    func setData(_ data: EventsData) {
        self.selectionStyle = .none

        self.superView.layer.cornerRadius = 8
        self.superView.layer.borderWidth = 1
        self.superView.layer.borderColor = UIColor (hex: "740001").cgColor

        self.eventName.text = data.name
        self.address.text = data.venue

        guard let date = data.date else { return }

        self.date.text = date.dateAsString() + "\n" + date.monthAsString().uppercased()
        self.time.text = date.dayAsString() + " at " + date.timeAsString()
    }
}
