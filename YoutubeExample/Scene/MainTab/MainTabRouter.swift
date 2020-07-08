//
//  MainTabRouter.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import UIKit

protocol MainTabInteractable: Interactable, HomeListener, PlayerListener {
    var router: MainTabRouting? { get set }
    var listener: MainTabListener? { get set }
}

protocol MainTabViewControllable: ViewControllable {
    func setViewControllers(viewControllers: [ViewControllable], animated: Bool)
    func showViewController(viewController: ViewControllable)
    func dismissViewController(viewController: ViewControllable, completion: (() -> Void)?)
}

final class MainTabRouter: ViewableRouter<MainTabInteractable, MainTabViewControllable>, MainTabRouting {

    init(
        interactor: MainTabInteractable,
        viewController: MainTabViewControllable,
        homeBuilder: HomeBuildable,
        playerBuilder: PlayerBuildable
    ) {
        self.homeBuilder = homeBuilder
        self.playerBuilder = playerBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    private let homeBuilder: HomeBuildable
    private var home: HomeRouting?
    private let playerBuilder: PlayerBuildable
    private var player: PlayerRouting?

    override func didLoad() {
        super.didLoad()

        setChilds()
    }

    private func setChilds() {
        let home = homeBuilder.build(withListener: interactor)
        attachChild(home)
        self.home = home

        let navHome = UINavigationController(root: home.viewControllable)
        navHome.setNavigationBarHidden(true, animated: true)
        viewController.setViewControllers(viewControllers: [navHome], animated: false)
    }

    // MARK: - MainTabRouting
    func showPlayer(with videoID: String) {
        guard player == nil else { return }

        let player = playerBuilder.build(withListener: interactor)
        attachChild(player)
        self.player = player

        viewController.showViewController(viewController: player.viewControllable)
    }

    func dismissPlayer() {
        guard let player = self.player else { return }
        viewController.dismissViewController(viewController: player.viewControllable) { [weak self] in
            self?.detachChild(player)
            self?.player = nil
        }
    }

}
