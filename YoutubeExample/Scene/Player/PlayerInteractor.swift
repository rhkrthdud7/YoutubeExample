//
//  PlayerInteractor.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import RxSwift

protocol PlayerRouting: ViewableRouting {}

protocol PlayerPresentable: Presentable {
    var listener: PlayerPresentableListener? { get set }
}

protocol PlayerListener: class {}

final class PlayerInteractor: PresentableInteractor<PlayerPresentable>, PlayerInteractable, PlayerPresentableListener {

    weak var router: PlayerRouting?
    weak var listener: PlayerListener?

    override init(presenter: PlayerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
