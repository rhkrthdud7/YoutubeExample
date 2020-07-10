//
//  HighlightingButton.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/03.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class HighlightingButton: UIButton {
    enum LayerShape {
        case circle, square
    }

    let layerHighlight = CALayer().then {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        $0.opacity = 0
    }

    let type: LayerShape

    init(type: LayerShape = .circle) {
        self.type = type
        super.init(frame: .zero)

        layer.addSublayer(layerHighlight)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layerHighlight.frame = bounds

        switch type {
        case .circle:
            layerHighlight.cornerRadius = bounds.height / 2
        case .square:
            layerHighlight.cornerRadius = 0
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        showLayerHighlight()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        hideLayerHighlight()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        hideLayerHighlight()
    }

    func showLayerHighlight() {
        let animation = CABasicAnimation()
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        layerHighlight.opacity = 1
        layerHighlight.add(animation, forKey: "opacity")
    }

    func hideLayerHighlight() {
        let animation = CABasicAnimation()
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 0.4
        layerHighlight.opacity = 0
        layerHighlight.add(animation, forKey: "opacity")
    }
}
