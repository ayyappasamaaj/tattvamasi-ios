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
import firebase_auth

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let defaults = UserDefaults.standard
    var collectionViewData: [HomeTransition]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        collectionViewData = HomeTransitionWorker().getHomeTransitionItems()
        collectionView.collectionViewLayout = HomeViewLayout()
        self.checkForAppUpdates()
        print(TestClass().methodToTest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkForRating()
    }
    
    /*
     * Code for Managing the
     * Install new update logic
     */
    func checkForAppUpdates() {

        guard let identifier: String = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
            let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String,
            let storeInfoURL = URL(string:Constants.ITUNES_LOOKUP_API + identifier) else {
                return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: storeInfoURL, completionHandler: { (data, response, error) in
            guard error == nil else { return }
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: data!) as? [String:Any],
                    let results = jsonData["results"] as? [[String:Any]],
                    let appStoreVersion = results[0]["version"] as? String,
                    let currentVersion = Float(version),
                    let storeVersion = Float(appStoreVersion) else {
                        return
                }

                if currentVersion < storeVersion {
                    let alert = UIAlertController(title: Constants.UPDATE_ALERT_HEADER, message: Constants.UPDATE_ALERT_MSG, preferredStyle: UIAlertController.Style.alert)
                    let action = UIAlertAction(title: Constants.UPDATE_ALERT_BUTTON, style: UIAlertAction.Style.default) { [weak self] _ in
                        self?.updateHandler()
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            } catch {

            }
        })
        task.resume()
    }
    
    func updateHandler() {
        guard let url = URL(string: Constants.ITUNES_URL) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
        let alert = UIAlertController(title: Constants.APP_STORE_RATING_HEADER, message: Constants.APP_STORE_RATING_MSG, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Constants.APP_STORE_RATING_YES, style: UIAlertAction.Style.default, handler: self.showRating))
        alert.addAction(UIAlertAction(title: Constants.APP_STORE_RATING_NO, style: UIAlertAction.Style.default, handler: self.noThanks))
        alert.addAction(UIAlertAction(title: Constants.APP_STORE_RATING_LATER, style: UIAlertAction.Style.default, handler: self.remindMeLater))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showRating(alert: UIAlertAction!) {
        defaults.set(false, forKey: "allowRating")
        defaults.set(0, forKey: "rateCounter")
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            guard let url = URL(string: Constants.ITUNES_URL_REVIEW) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = collectionViewData else {
            return 0
        }
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = collectionViewData,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BhajansCollectionViewCell", for: indexPath) as? BhajansCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.title.text = data[indexPath.row].title
        cell.imageView.image = UIImage(named: data[indexPath.row].imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = collectionViewData else {
            return
        }

        let payload: [String: Any]? = (indexPath.row == 2) ? ["category": "articles"] : nil
        navigate(to: data[indexPath.row].storyboardId, payload: payload)
    }
}

