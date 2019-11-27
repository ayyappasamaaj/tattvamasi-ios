//
//  EbookListWorker.swift
//  tattvamasi
//
//  Created by Suryanarayanan, Satyanarayan G on 11/24/19.
//  Copyright © 2019 Satya Surya. All rights reserved.
//

import Foundation
import FirebaseDatabase

class EbookListWorker {

    static var ref: DatabaseReference = Database.database().reference()

    static func getEbookList(for category: String?, subCategory: String?, callback: @escaping (([EbookData]) -> Void)) {

        guard var path = category else {
            callback([])
            return
        }

        if let subCat = subCategory {
            path.append(contentsOf: "/" + subCat)
        }

        ref.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let response = snapshot.value as? [[String: Any]] else {
                callback([])
                return
            }

            let bookList = organizeEbookResponse(data: response)
            callback(bookList)
        }
    }

    static func getPoojaCategories(callback: @escaping (([String]) -> Void)) {
        ref.child("pooja_categories").observeSingleEvent(of: .value) { res in
            guard let response = res.value as? [String] else {
                callback([])
                return
            }
            callback(response)
        }
    }

    private static  func organizeEbookResponse(data: [[String: Any]]) -> [EbookData] {
        var ebookList: [EbookData] = []
        for record in data {
            if let title = record["itemTitle"] as? String,
                let url = record["fileUrl"] as? String,
                let language = record["language"] as? String {
                ebookList.append(EbookData(title: title, url: url, language: language))
            }
        }
        return ebookList
    }
}
