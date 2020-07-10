//
//  MainTabInteractor.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import ReactorKit
import RxSwift

protocol MainTabRouting: ViewableRouting { }

protocol MainTabPresentable: Presentable {
    var listener: MainTabPresentableListener? { get set }
}

protocol MainTabListener: class { }

final class MainTabInteractor: PresentableInteractor<MainTabPresentable>, MainTabInteractable, MainTabPresentableListener, Reactor {

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

    // MARK: - Reactor
    var initialState = State()

    struct State {
        var selectedIndex: Int = 0
    }
    enum Action {
        case tapButton(Int)
    }
    enum Mutation {
        case setIndex(Int)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapButton(let index):
            return Observable.just(Mutation.setIndex(index))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setIndex(let index):
            state.selectedIndex = index
        }
        return state
    }
}
