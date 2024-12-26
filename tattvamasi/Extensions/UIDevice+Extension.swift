//
//  UIDevice+Extension.swift
//  tattvamasi
//
//  Created by Satya Surya on 11/25/23.
//  Copyright © 2023 Satya Surya. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    static func isIpad() -> Bool {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return true
        default:
            return false
        }
    }
    
}
