//
//  RootRouter.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, MainTabListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func replaceModal(viewController: ViewControllable?)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        mainTabBuilder: MainTabBuildable
    ) {
        self.mainTabBuilder = mainTabBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    private let mainTabBuilder: MainTabBuildable
    private var mainTab: MainTabRouting?

    override func didLoad() {
        super.didLoad()

        routeToMainTab()
    }

    private func routeToMainTab() {
        let mainTab = mainTabBuilder.build(withListener: interactor)
        attachChild(mainTab)
        self.mainTab = mainTab
        viewController.replaceModal(viewController: mainTab.viewControllable)
    }

}
