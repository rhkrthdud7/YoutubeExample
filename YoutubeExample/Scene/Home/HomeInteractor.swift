//
//  HomeInteractor.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import RxSwift
import ReactorKit

protocol HomeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol HomeListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener, Reactor {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: HomePresentable) {
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

    // MARK: - Reactor
    var initialState = State()

    struct State {
        var data: [String] = Array(1...40).map(String.init)
        var text: String = ""
    }
    enum Action {
        case tapUpload
        case tapSearch
        case tapAccount
        case tapCell(Int)
    }
    enum Mutation {
        case printLog(String)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapUpload:
            return Observable.just(Mutation.printLog("upload"))
        case .tapSearch:
            return Observable.just(Mutation.printLog("search"))
        case .tapAccount:
            return Observable.just(Mutation.printLog("account"))
        case .tapCell(let row):
            return Observable.just(Mutation.printLog("row: \(row)"))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .printLog(let string):
            state.text = string
        }
        return state
    }

}
