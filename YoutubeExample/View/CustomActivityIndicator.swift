//
//  CustomActivityIndicator.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/08.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class CustomActivityIndicator: UIView {
    public var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }
    public var state: CGFloat = 0 {
        didSet {
            guard !isAnimating else { return }

            layerCircle.strokeEnd = min(state, Metric.breakPoint2)
            layerCircle.transform = CATransform3DMakeRotation(.pi * state, 0, 0, 1)

            if state >= 0.5 {
                guard alpha != 1 else { return }
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 1
                }
            } else {
                guard alpha != 0.5 else { return }
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 0.5
                }
            }
        }
    }

    private enum Metric {
        static let lengthRatio: CGFloat = 33 / 32
        static let fullLength = lengthRatio * 360
        static let additionalLength = fullLength - 360
        static let circleLengthRatio = 360 / fullLength
        static let additionalLengthRatio = additionalLength / fullLength
        static let breakPoint1: CGFloat = 0.2
        static let breakPoint2: CGFloat = 0.9
    }

    private let layerCircle = CAShapeLayer()

    public init(color: UIColor = 0x8F8F8F.color) {
        super.init(frame: .zero)

        setCircle(color: color)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        layoutCircle()
    }

    private func setCircle(color: UIColor) {
        let startAngle: CGFloat = -.pi / 2
        let path = UIBezierPath(arcCenter: .zero, radius: 9, startAngle: startAngle, endAngle: startAngle + .pi * 2 * Metric.lengthRatio, clockwise: true)

        layerCircle.path = path.cgPath
        layerCircle.lineWidth = 2.5
        layerCircle.fillColor = nil
        layerCircle.strokeColor = color.cgColor
        layerCircle.strokeStart = Metric.breakPoint1 - Metric.additionalLengthRatio
        layerCircle.actions = [
            "position": NSNull(),
            "strokeEnd": NSNull(),
            "transform": NSNull()
        ]
        layer.addSublayer(layerCircle)

        let end1: CGFloat = Metric.breakPoint1
        let end2: CGFloat = Metric.breakPoint2
        let end3: CGFloat = 1
        let end4: CGFloat = Metric.additionalLengthRatio

        let start1: CGFloat = end1 - end4
        let start2: CGFloat = Metric.circleLengthRatio
        let start3: CGFloat = 0

        print(end1)
        print(end2)
        print(end3)
        print(end4)
        print()
        print(start1)
        print(start2)
        print(start3)
    }

    private func layoutCircle() {
        let frame = CGRect(x: bounds.width / 2, y: bounds.height / 2, width: 0, height: 0)
        layerCircle.frame = frame
    }

    private func startAnimating() {
        let end1: CGFloat = Metric.breakPoint1
        let end2: CGFloat = Metric.breakPoint2
        let end3: CGFloat = 1
        let end4: CGFloat = Metric.additionalLengthRatio

        let start1: CGFloat = end1 - end4
        let start2: CGFloat = Metric.circleLengthRatio
        let start3: CGFloat = 0

        let duration1: CFTimeInterval = 0.6
        let duration2: CFTimeInterval = 0.4
        let duration3: CFTimeInterval = 0.3

        let strokeStart1 = CABasicAnimation(keyPath: "strokeStart")
        strokeStart1.beginTime = 0
        strokeStart1.fromValue = start1
        strokeStart1.toValue = start1
        strokeStart1.duration = duration1

        let strokeStart2 = CABasicAnimation(keyPath: "strokeStart")
        strokeStart2.beginTime = duration1
        strokeStart2.fromValue = start1
        strokeStart2.toValue = start2
        strokeStart2.duration = duration2

        let strokeStart3 = CABasicAnimation(keyPath: "strokeStart")
        strokeStart3.beginTime = duration1 + duration2
        strokeStart3.fromValue = start3
        strokeStart3.toValue = start1
        strokeStart3.duration = duration3

        let strokeEnd1 = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd1.beginTime = 0
        strokeEnd1.fromValue = end1
        strokeEnd1.toValue = end2
        strokeEnd1.duration = duration1

        let strokeEnd2 = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd2.beginTime = duration1
        strokeEnd2.fromValue = end2
        strokeEnd2.toValue = end3
        strokeEnd2.duration = duration2

        let strokeEnd3 = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd3.beginTime = duration1 + duration2
        strokeEnd3.fromValue = end4
        strokeEnd3.toValue = end1
        strokeEnd3.duration = duration3

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [strokeStart1, strokeStart2, strokeStart3, strokeEnd1, strokeEnd2, strokeEnd3]
        groupAnimation.duration = duration1 + duration2 + duration3
        groupAnimation.fillMode = .forwards
        groupAnimation.timeOffset = duration1 * Double(layerCircle.strokeEnd)
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false

        layerCircle.add(groupAnimation, forKey: "stroke")

        let rotation = CABasicAnimation()
        rotation.fromValue = CGFloat.zero
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 2
        rotation.timeOffset = Double(layerCircle.strokeEnd)
        rotation.repeatCount = .infinity

        layerCircle.add(rotation, forKey: "transform.rotation")
    }

    private func stopAnimating() {
        alpha = 0
        layerCircle.removeAllAnimations()
    }
}

extension Reactive where Base: CustomActivityIndicator {
    public var isAnimating: Binder<Bool> {
        return Binder(base) { activityIndicator, isAnimating in
            activityIndicator.isAnimating = isAnimating
        }
    }
    public var state: Binder<CGFloat> {
        return Binder(base) { activityIndicator, state in
            activityIndicator.state = state
        }
    }

}
