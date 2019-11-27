//
//  StringExtension.swift
//
//  Created by Suryanarayanan, Satyanarayan on 3/7/16.
//  Copyright (c) 2016 Suryanarayanan, Satyanarayan. All rights reserved.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.count
    }
}
