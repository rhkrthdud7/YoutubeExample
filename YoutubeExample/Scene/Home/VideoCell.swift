//
//  VideoCell.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/05.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit
import ReactorKit
import Then

class VideoCell: BaseTableViewCell, View {
    typealias Reactor = VideoCellReactor
    
    private enum Color {
        static let darkBlack = 0x1F1F1F.color
    }
    
    override func initialize() {
        super.initialize()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    func bind(reactor: Reactor) {
        textLabel?.text = reactor.currentState.id
        textLabel?.textColor = .white
    }

}
