//
//  Constants.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/30/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import Foundation

struct Constants {
    
    // Static Values
    
    
    // Static URLs
    static let ITUNES_URL                   = "https://itunes.apple.com/us/app/tattvamasi/id1292928285?mt=8"
    static let ITUNES_URL_REVIEW            = "https://itunes.apple.com/us/app/tattvamasi/id1292928285?mt=8&action=write-review"
    static let PAYPAL_DONATION_URL          = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4M73DVTGB3BNY"
    
    //  API Endpoints
    static let ITUNES_LOOKUP_API            = "http://itunes.apple.com/lookup?bundleId="
    
    // Suggestive Messages
    static let APP_VERSION_INFO             = "App Version: "
    static let UPDATE_ALERT_HEADER          = "Update Available"
    static let UPDATE_ALERT_MSG             = "Please update the app to the latest version to continue."
    static let UPDATE_ALERT_BUTTON          = "Update Now"
    static let APP_STORE_RATING_HEADER      = "Rate Us"
    static let APP_STORE_RATING_MSG         = "Enjoying Tattvamasi app? \n Would you like to give us a rating in the App Store?"
    static let APP_STORE_RATING_YES         = "Yes, Rate Now"
    static let APP_STORE_RATING_LATER       = "Remind Later"
    static let APP_STORE_RATING_NO          = "No, Thanks"
    
    // Error Messages
    static let WEBVIEW_LOAD_ERROR_HEADER    = "Problem loading"
    static let WEBVIEW_LOAD_ERROR_MSG       = "There is some problem is loading this page. Please try again later."
    static let NETWORK_ERROR_HEADER         = "Network Connectivity"
    static let NETWORK_ERROR_MSG            = "Error fetching data. Please try again later."
}
