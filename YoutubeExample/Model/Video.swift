//
//  Video.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/04.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation

struct Video: Equatable {
    static func == (lhs: Video, rhs: Video) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String

    let title: String
    let description: String
    let author: String

    let date: Date

    let viewCount: Int
    let likeCount: Int
    let dislikeCount: Int

    let duration: Int

    var videoURL: URL? {
        return Bundle.main.url(forResource: id, withExtension: "mp4")
    }
    var thumbnailURL: URL? {
        return Bundle.main.url(forResource: id, withExtension: "png")
    }

    static var allVideos: [Video] {
        return [
            Video(
                id: "5317",
                title: "Carousel",
                description: "",
                author: "Carousel",
                date: Date(),
                viewCount: 1203,
                likeCount: 350,
                dislikeCount: 16,
                duration: 88),
            Video(
                id: "10001",
                title: "Creek",
                description: "",
                author: "Creek",
                date: Date(),
                viewCount: 1203,
                likeCount: 350,
                dislikeCount: 16,
                duration: 88),
            Video(
                id: "21475",
                title: "Morocco",
                description: "",
                author: "Morocco",
                date: Date(),
                viewCount: 1203,
                likeCount: 350,
                dislikeCount: 16,
                duration: 88),
            Video(
                id: "25445",
                title: "Fire",
                description: "",
                author: "Fire",
                date: Date(),
                viewCount: 1203,
                likeCount: 350,
                dislikeCount: 16,
                duration: 88),
            Video(
                id: "28368",
                title: "Ducks",
                description: "",
                author: "Ducks",
                date: Date(),
                viewCount: 1203,
                likeCount: 350,
                dislikeCount: 16,
                duration: 88),
            Video(
                id: "35866",
                title: "Composition",
                description: "",
                author: "Composition",
                date: Date(),
                viewCount: 1203,
                likeCount: 350,
                dislikeCount: 16,
                duration: 88),
            Video(
                id: "35881",
                title: "Carousel",
                description: "",
                author: "Carousel",
                date: Date(),
                viewCount: 1203,
                likeCount: 350,
                dislikeCount: 16,
                duration: 88),
            Video(
                id: "41170",
                title: "Cascade",
                description: "",
                author: "Cascade",
                date: Date(),
                viewCount: 1203,
                likeCount: 350,
                dislikeCount: 16,
                duration: 88),
        ]
    }
}
