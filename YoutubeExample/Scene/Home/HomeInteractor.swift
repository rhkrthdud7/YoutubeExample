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

    let videoService: VideoServiceType

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: HomePresentable,
        videoService: VideoServiceType
    ) {
        self.videoService = videoService
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
        var videos: [Video] = []
        var isLoading: Bool = false
    }
    enum Action {
        case initialLoad
        case refresh
        case tapUpload
        case tapSearch
        case tapAccount
        case tapCell(Int)
    }
    enum Mutation {
        case setVideos([Video])
        case setLoading(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialLoad:
            return fetchVideos()
        case .refresh:
            guard !currentState.isLoading else { return .empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                fetchVideos().delay(.seconds(2), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
                ])
        case .tapUpload, .tapSearch, .tapAccount, .tapCell:
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setVideos(let videos):
            state.videos = videos
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
    
    private func fetchVideos() -> Observable<Mutation> {
        return videoService
            .fetchVideos()
            .map { Mutation.setVideos($0) }
    }

}
