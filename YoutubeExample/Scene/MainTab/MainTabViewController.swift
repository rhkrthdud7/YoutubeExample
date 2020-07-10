//
//  MainTabViewController.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import ReactorKit
import RxSwift
import RxCocoa
import UIKit
import SwiftyColor

protocol MainTabPresentableListener: class { }

final class MainTabViewController: BaseViewController, MainTabPresentable, MainTabViewControllable, View {

    weak var listener: MainTabPresentableListener?
    var viewControllers: [UIViewController]?

    private enum Color {
        static let lightBlack = 0x282828.color
        static let darkBlack = 0x212121.color
        static let border = 0x373737.color
    }
    private enum Metric {
        static let tabBarContentHeight: CGFloat = 48
    }

    let viewContainer = UIView().then {
        $0.backgroundColor = Color.darkBlack
    }
    let viewTabBar = UIView().then {
        $0.backgroundColor = Color.lightBlack
    }
    let viewBottom = UIView().then {
        $0.backgroundColor = Color.lightBlack
    }
    let stackViewTab = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    let buttonHome = TabBarButton().then {
        $0.setTitle("홈", for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_home"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonExplore = TabBarButton().then {
        $0.setTitle("탐색", for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_home"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonSubscription = TabBarButton().then {
        $0.setTitle("구독", for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_home"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonInbox = TabBarButton().then {
        $0.setTitle("수신함", for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_home"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonLibrary = TabBarButton().then {
        $0.setTitle("보관함", for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_home"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }

    override func setupConstraints() {
        setupViews()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var childForStatusBarStyle: UIViewController? {
        return children.first
    }

    private func addChild(viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        self.addChild(viewController)
        self.viewContainer.addSubview(viewController.view)
        viewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        viewController.didMove(toParent: self)
        setNeedsStatusBarAppearanceUpdate()
    }

    private func removeChild(viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
        setNeedsStatusBarAppearanceUpdate()
    }

    // MARK: - MainTabViewControllable
    func setViewControllers(viewControllers: [ViewControllable]) {
        let viewControllers = viewControllers.map { $0.uiviewController }
        self.viewControllers = viewControllers
        guard let reactor = reactor else { return }
        let index = reactor.currentState.selectedIndex
        reactor.action.on(.next(.tapButton(index)))
    }

    func bind(reactor: MainTabInteractor) {
        buttonHome.rx.tap
            .map { Reactor.Action.tapButton(0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        buttonExplore.rx.tap
            .map { Reactor.Action.tapButton(1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        buttonSubscription.rx.tap
            .map { Reactor.Action.tapButton(2) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        buttonInbox.rx.tap
            .map { Reactor.Action.tapButton(3) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        buttonLibrary.rx.tap
            .map { Reactor.Action.tapButton(4) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.selectedIndex }
            .map { $0 == 0 ? 1 : 0.5 }
            .bind(to: buttonHome.rx.alpha)
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.selectedIndex }
            .map { $0 == 1 ? 1 : 0.5 }
            .bind(to: buttonExplore.rx.alpha)
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.selectedIndex }
            .map { $0 == 2 ? 1 : 0.5 }
            .bind(to: buttonSubscription.rx.alpha)
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.selectedIndex }
            .map { $0 == 3 ? 1 : 0.5 }
            .bind(to: buttonInbox.rx.alpha)
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.selectedIndex }
            .map { $0 == 4 ? 1 : 0.5 }
            .bind(to: buttonLibrary.rx.alpha)
            .disposed(by: disposeBag)

        let selectedViewController = reactor.state
            .map { $0.selectedIndex }
            .subscribeOn(MainScheduler.instance)
            .map({ [weak self] index -> UIViewController? in
                guard
                    let self = self,
                    let viewControllers = self.viewControllers,
                    index < viewControllers.count
                    else { return nil }
                return viewControllers[index]
            })
            .distinctUntilChanged()

        Observable.zip(selectedViewController, selectedViewController.skip(1))
            .subscribe(onNext: { [weak self] previous, next in
                guard let self = self else { return }
                self.removeChild(viewController: previous)
                self.addChild(viewController: next)
            })
            .disposed(by: disposeBag)
    }
}

extension MainTabViewController {
    func setupViews() {
        view.backgroundColor = Color.darkBlack

        view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Metric.tabBarContentHeight)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        let viewBottomBorder = UIView().then {
            $0.backgroundColor = Color.border
        }
        viewBottom.addSubview(viewBottomBorder)
        viewBottomBorder.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        view.addSubview(viewTabBar)
        viewTabBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(viewBottom)
        }
        let viewTabBarBorder = UIView().then {
            $0.backgroundColor = Color.border
        }
        viewTabBar.addSubview(viewTabBarBorder)
        viewTabBarBorder.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        viewTabBar.addSubview(stackViewTab)
        stackViewTab.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(viewTabBar.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.tabBarContentHeight)
        }
        view.addSubview(viewContainer)
        viewContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(viewBottom.snp.top)
        }

        stackViewTab.addArrangedSubview(buttonHome)
        stackViewTab.addArrangedSubview(buttonExplore)
        stackViewTab.addArrangedSubview(buttonSubscription)
        stackViewTab.addArrangedSubview(buttonInbox)
        stackViewTab.addArrangedSubview(buttonLibrary)
    }
}
