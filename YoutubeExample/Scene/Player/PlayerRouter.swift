//
//  PlayerRouter.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol PlayerInteractable: Interactable {
    var router: PlayerRouting? { get set }
    var listener: PlayerListener? { get set }
}

protocol PlayerViewControllable: ViewControllable {}

final class PlayerRouter: ViewableRouter<PlayerInteractable, PlayerViewControllable>, PlayerRouting {

    override init(interactor: PlayerInteractable, viewController: PlayerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
