//
//  RootRouter.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, MainTabListener, SplashListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func replaceModal(viewController: ViewControllable?, animated: Bool)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        mainTabBuilder: MainTabBuildable,
        splashBuilder: SplashBuildable
    ) {
        self.mainTabBuilder = mainTabBuilder
        self.splashBuilder = splashBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    private let mainTabBuilder: MainTabBuildable
    private var mainTab: MainTabRouting?
    private let splashBuilder: SplashBuildable
    private var splash: SplashRouting?

    override func didLoad() {
        super.didLoad()

        routeToSplash()
    }

    private func routeToSplash() {
        let splash = splashBuilder.build(withListener: interactor)
        attachChild(splash)
        self.splash = splash
        viewController.replaceModal(viewController: splash.viewControllable, animated: false)
    }

    // MARK: - RootRouting
    func routeToMainTab() {
        if let child = splash {
            detachChild(child)
            splash = nil
        }
        let mainTab = mainTabBuilder.build(withListener: interactor)
        attachChild(mainTab)
        self.mainTab = mainTab
        viewController.replaceModal(viewController: mainTab.viewControllable, animated: true)
    }

}
