//
//  PlayerBuilder.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol PlayerDependency: Dependency {}

final class PlayerComponent: Component<PlayerDependency> {}

// MARK: - Builder

protocol PlayerBuildable: Buildable {
    func build(withListener listener: PlayerListener) -> PlayerRouting
}

final class PlayerBuilder: Builder<PlayerDependency>, PlayerBuildable {

    override init(dependency: PlayerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PlayerListener) -> PlayerRouting {
//        let component = PlayerComponent(dependency: dependency)
        let viewController = PlayerViewController()
        let interactor = PlayerInteractor(presenter: viewController)
        interactor.listener = listener
        return PlayerRouter(interactor: interactor, viewController: viewController)
    }
}
