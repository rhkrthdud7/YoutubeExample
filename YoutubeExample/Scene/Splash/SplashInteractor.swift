//
//  SplashInteractor.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import RxSwift

protocol SplashRouting: ViewableRouting {}

protocol SplashPresentable: Presentable {
    var listener: SplashPresentableListener? { get set }
}

protocol SplashListener: class {
    func didFinishSplashAnimation()
}

final class SplashInteractor: PresentableInteractor<SplashPresentable>, SplashInteractable, SplashPresentableListener {

    weak var router: SplashRouting?
    weak var listener: SplashListener?

    override init(presenter: SplashPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - SplashPresentableListener
    func didFinishSplashAnimation() {
        listener?.didFinishSplashAnimation()
    }
}
