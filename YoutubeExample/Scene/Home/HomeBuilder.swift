//
//  HomeBuilder.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol HomeDependency: Dependency {
    var videoService: VideoServiceType { get }
}

final class HomeComponent: Component<HomeDependency> {
    var videoService: VideoServiceType {
        return dependency.videoService
    }
}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HomeListener) -> HomeRouting {
        let component = HomeComponent(dependency: dependency)
        let viewController = HomeViewController()
        viewController.tabBarItem.image = #imageLiteral(resourceName: "icon_home")
        viewController.tabBarItem.title = "홈"
        let interactor = HomeInteractor(
            presenter: viewController,
            videoService: component.videoService
        )
        interactor.listener = listener
        viewController.reactor = interactor
        return HomeRouter(interactor: interactor, viewController: viewController)
    }
}
