//
//  PlayerViewController.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol PlayerPresentableListener: class { }

final class PlayerViewController: UIViewController, PlayerPresentable, PlayerViewControllable {

    weak var listener: PlayerPresentableListener?
    private var mode: Mode = .full {
        didSet {
            guard let view = view?.superview else { return }
            var frame: CGRect
            if mode == .full {
                frame = Metric.fullFrame
            } else {
                frame = Metric.miniFrame
            }
            UIView.animate(withDuration: 0.2) {
                view.frame = frame
            }
        }
    }

    private enum Mode {
        case full, mini
    }
    private enum Metric {
        static let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? .zero
        static let bounds = UIScreen.main.bounds
        static let minX: CGFloat = 0
        static let maxX: CGFloat = miniBarPadding
        static let minY: CGFloat = 0
        static let maxY: CGFloat = bounds.height - miniBarHeight * 2 - bottom
        static let minWidth: CGFloat = bounds.width - maxX * 2
        static let maxWidth: CGFloat = bounds.width
        static let minHeight: CGFloat = miniBarHeight
        static let maxHeight: CGFloat = bounds.height
        static let miniBarPadding: CGFloat = 8
        static let miniBarHeight: CGFloat = 56
        static let fullFrame = CGRect(x: minX, y: minY, width: maxWidth, height: maxHeight)
        static let miniFrame = CGRect(x: maxX, y: maxY, width: minWidth, height: minHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    func setupViews() {
        view.backgroundColor = .red
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
    }

    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
        let minX = Metric.minX
        let maxX = Metric.maxX
        let minY = Metric.minY
        let maxY = Metric.maxY
        let minWidth = Metric.minWidth
        let maxWidth = Metric.maxWidth
        let minHeight = Metric.minHeight
        let maxHeight = Metric.maxHeight

        guard let view = gesture.view?.superview else { return }
        if gesture.state == .changed {
            let translation = gesture.translation(in: view)
            var frame = view.frame
            let y = frame.origin.y + translation.y
            let ratio = y / maxY
            let x = maxX * ratio
            let width = (maxWidth - minWidth) * (1 - ratio) + minWidth
            let height = (maxHeight - minHeight) * (1 - ratio) + minHeight
            frame.origin.x = min(max(x, minX), maxX)
            frame.origin.y = min(max(y, minY), maxY)
            frame.size.width = min(max(width, minWidth), maxWidth)
            frame.size.height = min(max(height, minHeight), maxHeight)
            view.frame = frame
            gesture.setTranslation(.zero, in: view)
        } else if gesture.state == .ended {
            if mode == .full && view.frame.minY > maxY / 4 {
                mode = .mini
            } else if mode == .mini && view.frame.minY < maxY * 3 / 4 {
                mode = .full
            } else {
                let current = mode
                mode = current
            }
        }
    }

}
