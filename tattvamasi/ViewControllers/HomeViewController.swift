//
//  HomeViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/24/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewLayout: HomeViewLayout!
    let defaults = UserDefaults.standard
    var collectionViewData: [String] = ["Bhajans", "Pooja", "Articles", "Events", "Donate", "About us"]
    var collectionImages: [String] = ["bhajan.png", "pooja.png", "article.png", "calendar.png", "donate.png", "ayyappan.png"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionViewLayout = HomeViewLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        self.checkForAppUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkForRating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "homeToList") {
            let targetVC = segue.destination as! EbookListViewController
            targetVC.parentScreen = "Home"
            targetVC.category = "articles"
            targetVC.subCategory = ""
        }
    }
    
    /*
     * Code for Managing the
     * Install new update logic
     */
    func checkForAppUpdates() {
        
        let identifier: String = (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String)!
        let version: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String)!
        let storeInfoURL = URL(string:Constants.ITUNES_LOOKUP_API + identifier)!
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: storeInfoURL, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
            } else {
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: data!) as? [String:Any] {
                        if let results = jsonData["results"] as? [[String:Any]] {
                            let appStoreVersion = (results[0]["version"] as? String)!
                            
                            let currentVersion: Float = Float(version)!
                            let storeVersion: Float = Float(appStoreVersion)!
                            
                            if currentVersion < storeVersion {
                                let alert = UIAlertController(title: Constants.UPDATE_ALERT_HEADER, message: Constants.UPDATE_ALERT_MSG, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: Constants.UPDATE_ALERT_BUTTON, style: UIAlertActionStyle.default, handler: self.updateHandler))
                                self.present(alert, animated: true, completion: nil)
                            } 
                        }
                    }
                } catch {
                    
                }
            }
        })
        task.resume()
    }
    
    func updateHandler(alert: UIAlertAction!) {
        UIApplication.shared.openURL(URL(string: Constants.ITUNES_URL)!)
    }
    
    /*
     * Code for Managing the
     * App Store Rating Logic
     */
    func checkForRating() {
        
        if !defaults.bool(forKey: "firstTimeLaunch") {
            defaults.set(true, forKey: "firstTimeLaunch")
            defaults.set(true, forKey: "allowRating")
            defaults.set(0, forKey: "rateCounter")
        }
        
        if defaults.bool(forKey: "allowRating") {
            let counter = defaults.integer(forKey: "rateCounter")
            if (counter == 5) {
                self.askForRating()
            } else {
                defaults.set(counter + 1, forKey: "rateCounter")
            }
        }
    }
    
    func askForRating() {
        let alert = UIAlertController(title: Constants.APP_STORE_RATING_HEADER, message: Constants.APP_STORE_RATING_MSG, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Constants.APP_STORE_RATING_YES, style: UIAlertActionStyle.default, handler: self.showRating))
        alert.addAction(UIAlertAction(title: Constants.APP_STORE_RATING_NO, style: UIAlertActionStyle.default, handler: self.noThanks))
        alert.addAction(UIAlertAction(title: Constants.APP_STORE_RATING_LATER, style: UIAlertActionStyle.default, handler: self.remindMeLater))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showRating(alert: UIAlertAction!) {
        defaults.set(false, forKey: "allowRating")
        defaults.set(0, forKey: "rateCounter")
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            UIApplication.shared.openURL(URL(string: Constants.ITUNES_URL_REVIEW)!)
        }
    }
    
    func remindMeLater(alert: UIAlertAction!) {
        defaults.set(true, forKey: "allowRating")
        defaults.set(-15, forKey: "rateCounter")
    }
    
    func noThanks(alert: UIAlertAction!) {
        defaults.set(false, forKey: "allowRating")
        defaults.set(0, forKey: "rateCounter")
    }

    /*
     * Code for Managing the
     * Navigation from Collection View
     */
    func navigate(withIndex: Int) {
     
        var identifierString = ""
        
        switch withIndex {
        case 0:
            identifierString = "homeToBhajans"
            break;
        case 1:
            identifierString = "homeToPooja"
            break;
        case 2:
            identifierString = "homeToList"
            break;
        case 3:
            identifierString = "homeToEvents"
            break;
        case 4:
            identifierString = "homeToDonate"
            break;
        case 5:
            identifierString = "homeToAbout"
            break;
        default:
            break;
        }
        self.performSegue(withIdentifier: identifierString, sender: self)
    }

    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BhajansCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BhajansCollectionViewCell", for: indexPath) as! BhajansCollectionViewCell
        cell.title.text = self.collectionViewData[indexPath.row]
        cell.imageView.image = UIImage(named: self.collectionImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigate(withIndex: indexPath.row)
    }
}

