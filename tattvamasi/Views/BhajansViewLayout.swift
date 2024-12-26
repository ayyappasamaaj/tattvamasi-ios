//
//  BhajansViewLayout.swift
//  tattvamasi
//
//  Created by Suryanarayanan, Satyanarayan G on 7/7/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

class BhajansViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    var numberOfColumns: CGFloat {
        guard UIDevice.isIpad() else {
            return 3
        }
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            return 3
        case .landscapeLeft, .landscapeRight:
            return 4
        default:
            return 3
        }
    }
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let numberOfRows: CGFloat = 3
            let headerHeight: CGFloat = 64
            let iPadPadding: CGFloat = UIDevice.isIpad() ? 10 : 0
            
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            print(screenWidth)
            print(screenHeight)
            let itemWidth: CGFloat = (screenWidth - (numberOfColumns - 1) - iPadPadding) / numberOfColumns
            let itemHeight: CGFloat = (screenHeight - (numberOfRows - 1) - headerHeight) / numberOfRows
            print(itemWidth)
            print(itemHeight)
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    
}
