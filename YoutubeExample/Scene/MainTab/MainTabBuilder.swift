//
//  MainTabBuilder.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol MainTabDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainTabComponent: Component<MainTabDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MainTabBuildable: Buildable {
    func build(withListener listener: MainTabListener) -> MainTabRouting
}

final class MainTabBuilder: Builder<MainTabDependency>, MainTabBuildable {

    override init(dependency: MainTabDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainTabListener) -> MainTabRouting {
        let component = MainTabComponent(dependency: dependency)
        let viewController = MainTabViewController()
        viewController.tabBar.isOpaque = true
        viewController.tabBar.isTranslucent = false
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        let interactor = MainTabInteractor(presenter: viewController)
        interactor.listener = listener
        let homeBuilder = HomeBuilder(dependency: component)
        return MainTabRouter(
            interactor: interactor,
            viewController: viewController,
            homeBuilder: homeBuilder
        )
    }
}
