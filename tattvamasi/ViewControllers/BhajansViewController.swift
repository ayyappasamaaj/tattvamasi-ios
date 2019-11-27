//
//  BhajansViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/27/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

class BhajansViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewData: [BhajanTransition]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        collectionViewData = BhajanTransitionWorker().getTransitionItems()
        collectionView.collectionViewLayout = BhajansViewLayout()
    }
}

extension BhajansViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

        cell.title.text = data[indexPath.row].title.capitalized
        cell.imageView.image = UIImage(named: data[indexPath.row].imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = collectionViewData else {
            return
        }
        let payload: [String: Any] = ["category": "bhajans",
                                      "subCategory": data[indexPath.row].title as Any]
        navigate(to: "EbookListViewController", payload: payload)
    }
}
