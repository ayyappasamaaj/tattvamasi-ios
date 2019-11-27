//
//  EventsData.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/30/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import Foundation

struct EventsData {
    let name: String
    let desc: String
    let registrationLink: String
    let venue: String
    let dateString: String
    let date: Date?
    let endDate: Date?
    let latitude: Double?
    let longitude: Double?
    var showDetails: Bool?
}
