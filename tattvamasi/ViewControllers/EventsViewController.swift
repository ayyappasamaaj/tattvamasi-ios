//
//  EventsViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/27/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import EventKit

class EventsViewController: BaseViewController {
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    var eventsArray: [EventsData] = [] {
        didSet {
            self.loading.stopAnimating()
            self.eventsTableView.reloadData()
            self.eventsTableView.isHidden = false
        }
    }
    var selectedEvent: EventsData?
    var selectedIndex: Int?
    var gMapAvailable: Bool {
        guard let url = URL(string: Constants.GOOGLE_MAPS_SCHEME) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        eventsTableView.isHidden = true
        getEvents()
    }
    
    /*
     * Methods for handling
     * Set Reminder
     *
     */
    @IBAction func setReminder(_ sender: Any) {
        self.selectedEvent = self.eventsArray[(sender as AnyObject).tag]
        self.addEventToCalendar()
    }
    
    func addEventToCalendar() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { [weak self] granted, error in

            guard granted, error == nil, let eventSelected = self?.selectedEvent else {
                self?.showExceptionAlert(Constants.CALENDAR_GRANT_ACCESS_HDR, message: Constants.CALENDAR_GRANT_ACCESS)
                return
            }

            let event = EKEvent(eventStore: eventStore)
            event.title = eventSelected.name
            event.startDate = eventSelected.date
            event.endDate = eventSelected.endDate
            event.notes = eventSelected.desc
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
                self?.showExceptionAlert(Constants.EVENT_ADDED, message: eventSelected.name + " added to calendar on " + eventSelected.dateString)
            } catch let e as NSError {
                print(e.localizedDescription)
                self?.showExceptionAlert(Constants.ADD_EVENT_ERROR_HDR, message: Constants.ADD_EVENT_ERROR)
                return
            }
        }
    }
    
    
    /*
     * Methods for handling
     * Get Directions
     *
     */
    @IBAction func getDirections(_ sender: Any) {
        self.selectedEvent = self.eventsArray[(sender as AnyObject).tag]
        if (self.gMapAvailable) {
            let alert = UIAlertController(title: "", message: "Select your preferred navigation", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "Maps",
                                          style: UIAlertAction.Style.default,
                                          handler: {(alert: UIAlertAction!) in self.launchAppleMaps()}))
            alert.addAction(UIAlertAction(title: "Google Maps",
                                          style: UIAlertAction.Style.default,
                                          handler: {(alert: UIAlertAction!) in self.launchGoogleMaps()}))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.launchAppleMaps()
        }
    }
    
    func launchGoogleMaps()  {
        guard let lat = selectedEvent?.latitude,
            let long = selectedEvent?.longitude else {
            return
        }

        let latString = String(lat)
        let longString = String(long)

        guard let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latString),\(longString)&directionsmode=driving") else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func launchAppleMaps()  {

        guard let event = selectedEvent,
            let lat = event.latitude,
            let long = event.longitude else {
            return
        }

        let coordinate = CLLocationCoordinate2DMake(lat, long)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = event.venue
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    /*
     * Calling Firebase database to get the
     * List of events
     *
     */
    func getEvents() {
        EventsWorker.getAllEvents { [weak self] data in
            self?.eventsArray = data
        }
    }
}

extension EventsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let index = selectedIndex else {
            return UITableView.automaticDimension
        }
        return (indexPath.row == index) ? EventsTableViewCell.heightWithDesc : UITableView.automaticDimension
    }
}

extension EventsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data: EventsData = self.eventsArray[indexPath.row]

        switch indexPath.row {
        case selectedIndex:
            if let cell = self.eventsTableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as? EventsTableViewCell {
                cell.setData(data)
                cell.directionsButton.tag = indexPath.row
                cell.reminderButton.tag = indexPath.row
                return cell
            }
        default:
            if let cell = self.eventsTableView.dequeueReusableCell(withIdentifier: "EventsWithoutDescCell") as? EventsWithoutDescCell {
                cell.setData(data)
                return cell
            }
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedIndex, indexPath.row == index {
            selectedIndex = nil
        } else {
            selectedIndex = indexPath.row
        }
        eventsTableView.reloadData()
    }
}
