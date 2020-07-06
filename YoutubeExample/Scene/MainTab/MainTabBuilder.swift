//
//  MainTabBuilder.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol MainTabDependency: Dependency {}

final class MainTabComponent: Component<MainTabDependency> {

    let videoService: VideoServiceType

    init(
        dependency: MainTabDependency,
        videoService: VideoServiceType
    ) {
        self.videoService = videoService
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MainTabBuildable: Buildable {
    func build(withListener listener: MainTabListener) -> MainTabRouting
}

final class MainTabBuilder: Builder<MainTabDependency>, MainTabBuildable {

    override init(dependency: MainTabDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: MainTabListener
    ) -> MainTabRouting {
        let videoService = VideoService()
        let component = MainTabComponent(
            dependency: dependency,
            videoService: videoService
        )
        let viewController = MainTabViewController()
        viewController.tabBar.isOpaque = true
        viewController.tabBar.isTranslucent = false
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        let interactor = MainTabInteractor(presenter: viewController)
        interactor.listener = listener
        let homeBuilder = HomeBuilder(dependency: component)
        let playerBuilder = PlayerBuilder(dependency: component)
        return MainTabRouter(
            interactor: interactor,
            viewController: viewController,
            homeBuilder: homeBuilder,
            playerBuilder: playerBuilder
        )
    }
}
