//
//  SplashBuilder.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol SplashDependency: Dependency {}

final class SplashComponent: Component<SplashDependency> {}

// MARK: - Builder

protocol SplashBuildable: Buildable {
    func build(withListener listener: SplashListener) -> SplashRouting
}

final class SplashBuilder: Builder<SplashDependency>, SplashBuildable {

    override init(dependency: SplashDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SplashListener) -> SplashRouting {
        let viewController = SplashViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        let interactor = SplashInteractor(presenter: viewController)
        interactor.listener = listener
        return SplashRouter(interactor: interactor, viewController: viewController)
    }
}
