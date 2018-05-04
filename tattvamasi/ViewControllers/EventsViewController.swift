//
//  EventsViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/27/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EventsViewController: UIViewController {
    
    var ref: DatabaseReference!
    var eventsArray: NSMutableArray!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.eventsArray = NSMutableArray()
        self.eventsTableView.isHidden = true
        self.ref = Database.database().reference()
        self.getEbookList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Calling Firebase database to get the
     * List of events
     *
     */
    func getEbookList() {
        var eventsData: [EventsData] = []
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
                    eventsData.append(event)
                }
            }
        
            self.eventsArray = NSMutableArray(array: eventsData.sorted(by: {$0.date.compare($1.date) == .orderedAscending }))
            
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
        return EventsTableViewCell.height()
    }
}

extension EventsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let data: EventsData = self.eventsArray.object(at: indexPath.row) as? EventsData {
            let cell = self.eventsTableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as! EventsTableViewCell
            cell.setData(data)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showExceptionAlert("", message: "selected")
//        self.logEvent(actionName:"Read More Clicked", inScreen: Constants.NEWS_SCREEN)
//        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailNewsViewController") as! DetailNewsViewController
//        detailView.newsData = self.newsDataArray.object(at: indexPath.row) as! NewsData
//        detailView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        self.present(detailView, animated: true, completion: nil)
        
    }
}
