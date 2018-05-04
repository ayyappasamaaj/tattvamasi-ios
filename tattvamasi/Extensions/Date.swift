//
//  Date.swift
//  tattvamasi
//
//  Created by Satya Surya on 5/3/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import Foundation

extension Date {
    
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
    
    func dateAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd")
        return df.string(from: self)
    }
    
    func timeAsString() -> String {
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.setLocalizedDateFormatFromTemplate("hh:mm aaa")
        return df.string(from: self)
    }
    
    func dateAsDescription() -> String {
        let df = DateFormatter()
        df.timeStyle = DateFormatter.Style.medium
        df.dateStyle = DateFormatter.Style.medium
        df.timeZone = TimeZone.current
        return df.string(from: self)
    }
    
}
