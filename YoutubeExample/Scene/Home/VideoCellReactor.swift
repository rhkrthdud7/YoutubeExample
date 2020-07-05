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
    typealias Action = NoAction
    
    let initialState: Video

    init(video: Video) {
        self.initialState = video
    }
}
