//
//  BhajansViewController.swift
//  tattvamasi
//
//  Created by Satya Surya on 4/27/18.
//  Copyright © 2018 Satya Surya. All rights reserved.
//

import UIKit

class BhajansViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewLayout: BhajansViewLayout!
    var selectedSubCategory: String = ""
    var collectionViewData: [String] = ["ganesha", "guru", "muruga", "devi", "shiva", "vishnu", "rama", "hanuman", "ayyappan"]
    var collectionImages: [String] = ["ganesh.png", "guru.png", "murugan.png", "devi.png", "shivan.png", "vishnu.png", "ram.png", "hanuman.png", "ayyappan.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionViewLayout = BhajansViewLayout()
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "bhajansToList") {
            let targetVC = segue.destination as! EbookListViewController
            targetVC.parentScreen = "Bhajans"
            targetVC.category = "bhajans"
            targetVC.subCategory = self.selectedSubCategory
        }
    }
}

extension BhajansViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BhajansCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BhajansCollectionViewCell", for: indexPath) as! BhajansCollectionViewCell
        cell.title.text = self.collectionViewData[indexPath.row].capitalized
        cell.imageView.image = UIImage(named: self.collectionImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedSubCategory = self.collectionViewData[indexPath.row]
        self.performSegue(withIdentifier: "bhajansToList", sender: self)
    }
}
