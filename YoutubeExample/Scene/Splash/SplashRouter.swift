//
//  SplashRouter.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol SplashInteractable: Interactable {
    var router: SplashRouting? { get set }
    var listener: SplashListener? { get set }
}

protocol SplashViewControllable: ViewControllable {}

final class SplashRouter: ViewableRouter<SplashInteractable, SplashViewControllable>, SplashRouting {

    override init(interactor: SplashInteractable, viewController: SplashViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
