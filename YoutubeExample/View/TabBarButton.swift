//
//  TabBarButton.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/10.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class TabBarButton: UIButton {
    let layerHighlight = CALayer().then {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor
        $0.opacity = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.addSublayer(layerHighlight)

        imageView?.contentMode = .center
        titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        titleLabel?.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var frameLayer = bounds
        frameLayer.origin.y = (frameLayer.height - frameLayer.width) / 2
        frameLayer.size.height = bounds.width
        layerHighlight.frame = frameLayer
        layerHighlight.cornerRadius = bounds.width / 2

        guard let labelTitle = titleLabel, let imageView = imageView else { return }
        guard let text = labelTitle.text, !text.isEmpty, imageView.image != nil else { return }

        let imageViewRatio: CGFloat = 2 / 3
        let labelRatio: CGFloat = 1 - imageViewRatio

        let width = bounds.width
        let height = bounds.height - 10
        let frameImageView = CGRect(x: 0, y: 6, width: width, height: height * imageViewRatio)
        imageView.frame = frameImageView
        let frameLabel = CGRect(x: 0, y: frameImageView.maxY, width: width, height: height * labelRatio)
        labelTitle.frame = frameLabel
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
        let opacity = CABasicAnimation()
        opacity.fromValue = 0
        opacity.toValue = 1
        opacity.duration = 0.1
        let scale = CABasicAnimation()
        scale.fromValue = 0.7
        scale.toValue = 1
        scale.duration = 0.1
        layerHighlight.opacity = 1
        layerHighlight.add(opacity, forKey: "opacity")
        layerHighlight.add(scale, forKey: "transform.scale")
    }

    func hideLayerHighlight() {
        let opacity = CABasicAnimation()
        opacity.fromValue = 1
        opacity.toValue = 0
        opacity.duration = 0.1
        layerHighlight.opacity = 0
        layerHighlight.add(opacity, forKey: "opacity")
    }
}
