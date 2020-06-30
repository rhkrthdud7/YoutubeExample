//
//  MainTabRouter.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol MainTabInteractable: Interactable {
    var router: MainTabRouting? { get set }
    var listener: MainTabListener? { get set }
}

protocol MainTabViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MainTabRouter: ViewableRouter<MainTabInteractable, MainTabViewControllable>, MainTabRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MainTabInteractable, viewController: MainTabViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
