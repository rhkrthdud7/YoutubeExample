//
//  VideoCellReactor.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/05.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation
import ReactorKit

class VideoCellReactor: Reactor {
    init(video: Video) {
        let titleText = video.title
        let subtitleText = "\(video.author) • \(video.viewCount) • \(video.date)"
        let seconds = video.duration % 60
        let minutes = video.duration / 60
        let durationText = String(format: "%d:%d", minutes, seconds)

        self.initialState = State(
            id: video.id,
            titleText: titleText,
            subtitleText: subtitleText,
            durationText: durationText,
            thumbnailURL: video.thumbnailURL
        )
    }

    // MARK: - Reactor
    let initialState: State

    struct State {
        var id: String
        var titleText: String
        var subtitleText: String
        var durationText: String
        var thumbnailURL: URL?
    }
    enum Action {
        case tapMore
    }
    enum Mutation {
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapMore:
            return .empty()
        }
    }
}

extension VideoCellReactor: Equatable {
    static func == (lhs: VideoCellReactor, rhs: VideoCellReactor) -> Bool {
        return lhs.currentState.id == rhs.currentState.id
    }
}
