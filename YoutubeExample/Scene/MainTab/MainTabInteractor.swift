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
    func showPlayer(with videoID: String)
    func dismissPlayer()
}

protocol MainTabPresentable: Presentable {
    var listener: MainTabPresentableListener? { get set }
}

protocol MainTabListener: class { }

final class MainTabInteractor: PresentableInteractor<MainTabPresentable>, MainTabInteractable, MainTabPresentableListener {

    weak var router: MainTabRouting?
    weak var listener: MainTabListener?

    override init(presenter: MainTabPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - HomeListener
    func didSelectVideo(with videoID: String) {
        router?.showPlayer(with: videoID)
    }
}
