//
//  EventsData.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/30/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import Foundation

class EventsData: NSObject {
    var name: String = ""
    var desc: String = ""
    var registrationLink: String = ""
    var venue: String = ""
    var dateString: String = ""
    var date: Date!
    var latitude: Double!
    var longitude: Double!
    var showDetails: Bool = false
}
