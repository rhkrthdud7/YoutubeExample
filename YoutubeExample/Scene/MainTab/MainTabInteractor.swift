//
//  MainTabInteractor.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import RxSwift

protocol MainTabRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MainTabPresentable: Presentable {
    var listener: MainTabPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MainTabListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MainTabInteractor: PresentableInteractor<MainTabPresentable>, MainTabInteractable, MainTabPresentableListener {

    weak var router: MainTabRouting?
    weak var listener: MainTabListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MainTabPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
