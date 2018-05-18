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

class EventsViewController: UIViewController {
    
    var ref: DatabaseReference!
    var eventsArray: [EventsData] = []
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var gMapAvailable: Bool = false
    var selectedEvent: EventsData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.eventsTableView.isHidden = true
        self.ref = Database.database().reference()
        self.getEbookList()
        self.gMapAvailable = UIApplication.shared.canOpenURL(URL(string: Constants.GOOGLE_MAPS_SCHEME)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setReminder(_ sender: Any) {
        self.selectedEvent = self.eventsArray[(sender as AnyObject).tag]
    }
    
    @IBAction func getDirections(_ sender: Any) {
        self.selectedEvent = self.eventsArray[(sender as AnyObject).tag]
        
        if (self.gMapAvailable) {
            let alert = UIAlertController(title: "", message: "Select any app", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.launchAppleMaps()
        }
        
    }
    
    func launchGoogleMaps()  {
        
    }
    
    func launchAppleMaps()  {
        let coordinate = CLLocationCoordinate2DMake(self.selectedEvent.latitude, self.selectedEvent.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = self.selectedEvent.venue
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    /*
     * Calling Firebase database to get the
     * List of events
     *
     */
    func getEbookList() {
        self.ref.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            let events = snapshot.value as? NSArray
            for record in events! {
                let event: EventsData = EventsData()
                event.name =  (record as! [String : AnyObject])["name"] as! String
                event.desc =  (record as! [String : AnyObject])["desc"] as! String
                event.latitude =  (record as! [String : AnyObject])["latitude"] as! Double
                event.longitude =  (record as! [String : AnyObject])["longitude"] as! Double
                event.registrationLink =  (record as! [String : AnyObject])["registrationLink"] as! String
                event.venue =  (record as! [String : AnyObject])["venue"] as! String
                
                let millisecs = (record as! [String : AnyObject])["date"] as! Double
                event.date = Date(timeIntervalSince1970: millisecs)
                event.dateString = event.date.dateAsDescription()
                
                if  (event.date > Date()) {
                    self.eventsArray.append(event)
                }
            }
        
            self.eventsArray = self.eventsArray.sorted(by: {$0.date.compare($1.date) == .orderedAscending })
            
            DispatchQueue.main.async(execute: {
                self.loading.stopAnimating()
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = false
            })
            
        }) { (error) in
            DispatchQueue.main.async(execute: {
                self.loading.stopAnimating()
            })
            self.showExceptionAlert(Constants.NETWORK_ERROR_HEADER, message: Constants.NETWORK_ERROR_MSG)
            print(error.localizedDescription)
        }
    }
}

extension EventsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data: EventsData = self.eventsArray[indexPath.row]
        return EventsTableViewCell.height(showDetails: data.showDetails)
    }
}

extension EventsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data: EventsData = self.eventsArray[indexPath.row]
        let cell = self.eventsTableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as! EventsTableViewCell
        cell.setData(data)
        cell.directionsButton.tag = indexPath.row
        cell.reminderButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var i = 0;
        for event: EventsData in self.eventsArray {
            if (i == indexPath.row) {
                event.showDetails = !event.showDetails
            } else {
                event.showDetails = false
            }
            i += 1;
        }
        
        self.eventsTableView.reloadData()
    }
}
