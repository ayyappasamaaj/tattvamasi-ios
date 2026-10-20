//
//  EventsWorker.swift
//  tattvamasi
//
//  Created by Suryanarayanan, Satyanarayan G on 11/25/19.
//  Copyright © 2019 Satya Surya. All rights reserved.
//

import Foundation
import FirebaseDatabase

class EventsWorker {

    static var ref: DatabaseReference = Database.database().reference()

    static func getAllEvents(callback: @escaping (([EventsData]) -> Void)) {
        ref.child("events").observeSingleEvent(of: .value) { res in
            guard let response = res.value as? [[String: Any]] else {
                callback([])
                return
            }
            let events = parseEvents(eventsData: response)
            callback(events)
        }
    }

    private static func parseEvents(eventsData: [[String: Any]]) -> [EventsData] {
        var events: [EventsData] = []
        for event in eventsData {
            if let name = event["name"] as? String,
                let desc = event["desc"] as? String,
                let registrationLink = event["registrationLink"] as? String,
                let venue = event["venue"] as? String,
                let endSecs = event["endDate"] as? Double,
                let dateSecs = event["date"] as? Double {

                let endDate = Date(timeIntervalSince1970: endSecs)
                let date = Date(timeIntervalSince1970: dateSecs)
                let latitude = event["latitude"] as? Double
                let longitude = event["longitude"] as? Double
                let dateString = date.dateAsDescription()

                // Keep an event listed until it ends, so a multi-day event (e.g. the Mandalam season)
                // doesn't disappear on its first day
                if endDate > Date() {
                    events.append(EventsData(name: name, desc: desc, registrationLink: registrationLink, venue: venue, dateString: dateString, date: date, endDate: endDate, latitude: latitude, longitude: longitude, showDetails: false))
                }
            }
        }

        events = events.sorted(by: {
            $0.date?.compare($1.date ?? Date()) == .orderedAscending
        })
        return events
    }
}
