//
//  HomeTransitionWorker.swift
//  tattvamasi
//
//  Created by Suryanarayanan, Satyanarayan G on 11/22/19.
//  Copyright © 2019 Satya Surya. All rights reserved.
//

import Foundation

struct HomeTransition {
    let title, imageName, storyboardId: String
}

class HomeTransitionWorker {

    func getHomeTransitionItems() -> [HomeTransition] {
        var transitionItems: [HomeTransition] = []
        transitionItems.append(HomeTransition(title: "Bhajans", imageName: "bhajan.png", storyboardId: "BhajansViewController"))
        transitionItems.append(HomeTransition(title: "Pooja", imageName: "pooja.png", storyboardId: "PoojaViewController"))
        transitionItems.append(HomeTransition(title: "Articles", imageName: "article.png", storyboardId: "EbookListViewController"))
        transitionItems.append(HomeTransition(title: "Events", imageName: "calendar.png", storyboardId: "EventsViewController"))
        transitionItems.append(HomeTransition(title: "Donate", imageName: "donate.png", storyboardId: "DonateViewController"))
        transitionItems.append(HomeTransition(title: "About us", imageName: "ayyappan.png", storyboardId: "AboutUsViewController"))
        return transitionItems
    }
}
