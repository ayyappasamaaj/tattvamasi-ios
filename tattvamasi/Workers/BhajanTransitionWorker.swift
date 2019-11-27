//
//  BhajanTransition.swift
//  tattvamasi
//
//  Created by Suryanarayanan, Satyanarayan G on 11/22/19.
//  Copyright © 2019 Satya Surya. All rights reserved.
//

import Foundation

struct BhajanTransition {
    let title, imageName: String
}

class BhajanTransitionWorker {

    func getTransitionItems() -> [BhajanTransition] {
        var transitionItems: [BhajanTransition] = []
        transitionItems.append(BhajanTransition(title: "ganesha", imageName: "ganesh.png"))
        transitionItems.append(BhajanTransition(title: "guru", imageName: "guru.png"))
        transitionItems.append(BhajanTransition(title: "muruga", imageName: "murugan.png"))
        transitionItems.append(BhajanTransition(title: "devi", imageName: "devi.png"))
        transitionItems.append(BhajanTransition(title: "shiva", imageName: "shivan.png"))
        transitionItems.append(BhajanTransition(title: "vishnu", imageName: "vishnu.png"))
        transitionItems.append(BhajanTransition(title: "rama", imageName: "ram.png"))
        transitionItems.append(BhajanTransition(title: "hanuman", imageName: "hanuman.png"))
        transitionItems.append(BhajanTransition(title: "ayyappan", imageName: "ayyappan.png"))
        return transitionItems
    }
}
