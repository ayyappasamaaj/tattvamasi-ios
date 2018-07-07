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
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let numberOfColumns: CGFloat = 3
            let numberOfRows: CGFloat = 3
            let headerHeight: CGFloat = 64
            let iPadPadding: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 0
            
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            let itemWidth: CGFloat = (screenWidth - (numberOfColumns - 1) - iPadPadding) / numberOfColumns
            let itemHeight: CGFloat = (screenHeight - (numberOfRows - 1) - headerHeight) / numberOfRows
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    
}
