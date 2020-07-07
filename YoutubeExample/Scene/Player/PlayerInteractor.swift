//
//  PlayerInteractor.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import ReactorKit
import RxSwift

protocol PlayerRouting: ViewableRouting { }

protocol PlayerPresentable: Presentable {
    var listener: PlayerPresentableListener? { get set }
}

protocol PlayerListener: class { }

final class PlayerInteractor: PresentableInteractor<PlayerPresentable>, PlayerInteractable, PlayerPresentableListener, Reactor {

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

    enum PlayerViewMode {
        case full, mini
    }

    // MARK: - Reactor
    var initialState = State()

    struct State {
        var mode: PlayerViewMode = .full
    }
    enum Action {
        case setMode(PlayerViewMode)
    }
    enum Mutation {
        case setMode(PlayerViewMode)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setMode(let mode):
            return .just(Mutation.setMode(mode))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setMode(let mode):
            state.mode = mode
        }
        return state
    }
}
