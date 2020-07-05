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
        static let labelDescriptionText = 0x9A9A9A.color
    }
    private enum Metric {
        static let imageViewThumbnailRatio: CGFloat = 9.0 / 16.0
        static let imageViewProfileSize: CGFloat = 36
    }

    let imageViewThumbnail = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    let viewBottom = UIView().then {
        $0.backgroundColor = .clear
    }
    let viewDuration = UIView().then {
        $0.backgroundColor = Color.darkBlack
        $0.layer.cornerRadius = 3
        $0.layer.masksToBounds = true
    }
    let labelDuration = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .white
    }
    let imageViewProfile = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 18
        $0.layer.masksToBounds = true
        $0.image = #imageLiteral(resourceName: "image_profile")
    }
    let labelTitle = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
        $0.numberOfLines = 2
    }
    let labelSubtitle = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = Color.labelDescriptionText
        $0.numberOfLines = 1
    }
    let buttonMore = HighlightingButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_more"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }

    override func initialize() {
        super.initialize()

        selectionStyle = .none
        backgroundColor = .clear

        addSubview(imageViewThumbnail)
        imageViewThumbnail.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageViewThumbnail.snp.width).multipliedBy(Metric.imageViewThumbnailRatio)
        }
        addSubview(viewDuration)
        viewDuration.snp.makeConstraints {
            $0.trailing.equalTo(imageViewThumbnail).inset(6)
            $0.bottom.equalTo(imageViewThumbnail).inset(6)
        }
        viewDuration.addSubview(labelDuration)
        labelDuration.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.top.bottom.equalToSuperview().inset(3)
        }
        addSubview(viewBottom)
        viewBottom.snp.makeConstraints {
            $0.top.equalTo(imageViewThumbnail.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        viewBottom.addSubview(imageViewProfile)
        imageViewProfile.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.height.width.equalTo(Metric.imageViewProfileSize)
        }
        viewBottom.addSubview(buttonMore)
        buttonMore.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.trailing.equalToSuperview().offset(7)
            $0.width.height.equalTo(40)
        }
        viewBottom.addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalTo(imageViewProfile.snp.trailing).offset(12)
            $0.trailing.equalTo(buttonMore.snp.leading).offset(2)
        }
        viewBottom.addSubview(labelSubtitle)
        labelSubtitle.snp.makeConstraints {
            $0.top.equalTo(labelTitle.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(labelTitle)
            $0.bottom.equalToSuperview().inset(24)
        }

    }

    func bind(reactor: Reactor) {
        let imageView = imageViewThumbnail

        buttonMore.rx.tap
            .map { Reactor.Action.tapMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.titleText }
            .bind(to: labelTitle.rx.text)
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.subtitleText }
            .bind(to: labelSubtitle.rx.text)
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.durationText }
            .bind(to: labelDuration.rx.text)
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.thumbnailURL }
            .compactMap { $0 }
            .subscribeOn(ConcurrentMainScheduler.instance)
            .map { UIImage(contentsOfFile: $0.path) }
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { image in
                imageView.alpha = 0
                UIView.animate(withDuration: 0.2) {
                    imageView.alpha = 1
                    imageView.image = image
                }
            })
            .disposed(by: disposeBag)
    }

}
