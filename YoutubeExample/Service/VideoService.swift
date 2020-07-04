//
//  VideoServiceType.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/04.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation
import RxSwift

protocol VideoServiceType {
    func fetchVideos() -> Observable<[Video]>
}

class VideoService: VideoServiceType {
    func fetchVideos() -> Observable<[Video]> {
        return .just(Video.allVideos)
    }
}
