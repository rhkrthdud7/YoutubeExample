//
//  MainTabRouter.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol MainTabInteractable: Interactable, HomeListener {
    var router: MainTabRouting? { get set }
    var listener: MainTabListener? { get set }
}

protocol MainTabViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func setViewControllers(viewControllers: [ViewControllable], animated: Bool)
}

final class MainTabRouter: ViewableRouter<MainTabInteractable, MainTabViewControllable>, MainTabRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MainTabInteractable,
        viewController: MainTabViewControllable,
        homeBuilder: HomeBuildable
    ) {
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    private let homeBuilder: HomeBuildable
    private var home: HomeRouting?

    override func didLoad() {
        super.didLoad()

        setChilds()
    }

    private func setChilds() {
        let home = homeBuilder.build(withListener: interactor)
        attachChild(home)
        self.home = home

        viewController.setViewControllers(viewControllers: [home.viewControllable], animated: false)
    }

}
