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
import RxDataSources

typealias VideoListSection = SectionModel<Int, VideoCellReactor>

protocol HomeRouting: ViewableRouting { }

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
}

protocol HomeListener: class { }

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener, Reactor {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    let videoService: VideoServiceType

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
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - Reactor
    var initialState = State()

    struct State {
        var videos: [VideoListSection] = []
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
        case setVideos([VideoListSection])
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
                fetchVideos().delay(.seconds(3), scheduler: MainScheduler.instance),
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
            .map({ videos in
                let items = videos.map(VideoCellReactor.init)
                let section = VideoListSection(model: 0, items: items)
                return .setVideos([section])
            })
    }

}
